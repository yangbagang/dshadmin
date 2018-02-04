package com.ybg.dsh.pm

import com.ybg.dsh.enums.NodeType
import com.ybg.dsh.sys.SystemUser
import com.ybg.dsh.vo.AjaxPagingVo
import com.ybg.dsh.wf.FlowDefinition
import com.ybg.dsh.wf.TaskAssign
import com.ybg.dsh.wf.TaskForm
import com.ybg.dsh.wf.Transaction
import com.ybg.dsh.wf.WorkTask
import grails.gorm.transactions.Transactional

@Transactional
class ProjectTaskService {

    def listTask(SystemUser user, Integer status, Map params) {
        def c = ProjectTask.createCriteria()
        def taskIdList = TaskAssign.findAllBySystemUser(user)*.workTask*.id
        if (taskIdList == null || taskIdList.size() == 0) {
            taskIdList = []
            taskIdList.add(0L)
        }
        def data = c.list(params) {
            and {
                eq("status", status)
                'in'("taskId", taskIdList)
            }
            order("createTime", "asc")
        }

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = data.totalCount
        result.recordsFiltered = data.size()
        result
    }

    def complete(SystemUser user, Long taskId) {
        println("开始节点推进。。。")
        def now = new Date()
        def projectTask = ProjectTask.get(taskId)
        println("开始检查projectTask是否存在。。。")
        if (projectTask == null) return

        //标记当前任务为完成状态
        println("标记当前任务为完成状态。。。")
        projectTask.updateTime = now
        projectTask.updateUser = user
        projectTask.status = 1
        projectTask.save flush: true

        println("准备数据。。。")
        def projectFlow = projectTask.projectFlow
        def project = projectFlow.project

        //获取下一任务
        println("获取下一任务。。。")
        def tasks = getNextTasks(WorkTask.get(projectTask.taskId).taskId)
        if (tasks == null || tasks.isEmpty()) return

        //公共内容
        println("公共内容。。。")
        //去掉本次任务内容
        project.taskName = project.taskName.replace("[${projectTask.taskName}]", "")
        println("任务名称：${project.taskName}")
        project.updateUser = user
        project.updateTime = now
        projectFlow.updater = user
        projectFlow.updateTime = now

        //任务处理
        println("任务处理。。。")
        tasks.each { task ->
            //处理每一个任务节点
            processTask(task, project, projectTask, projectFlow, user, now)
        }

        //保存数据
        println("保存数据")
        projectFlow.save flush: true
        project.save flush: true
    }

    private processTask(WorkTask task, Project project, ProjectTask projectTask, ProjectFlow projectFlow,
                        SystemUser user, Date now) {
        //如果下一节点是普通任务节点
        if (NodeType.isTaskNode(task.taskType)) {
            println("将项目指向下一任务")
            //将项目指向下一任务
            project.taskName += "[${task.name}]"
            //创建新任务实例，创建新表单实例
            println("创建新任务实例，创建新表单实例")
            createTaskInstance(projectFlow, task, user, now)
        } else if (NodeType.isEndNode(task.taskType)) {
            //如果下一任务是结束任务
            //标记流程完成
            println("标记流程完成")
            projectFlow.status = 1
            //查找下一流程
            println("查找下一流程")
            def flowDefinition = FlowDefinition.findByPrevId(projectFlow.flowId)
            if (flowDefinition) {
                //如果存在，取得下一流程的第一个任务节点
                println("如果存在，取得下一流程的第一个任务节点")
                def newTask = getFirstTask(flowDefinition)
                if (newTask) {
                    //则将项目指向下一流程
                    println("则将项目指向下一流程")
                    project.flowId = flowDefinition.id
                    project.flowName = flowDefinition.name
                    project.flowVersion = flowDefinition.flowVersion
                    project.taskName = "[${newTask.name}]"
                    //创建新流程实例
                    println("创建新流程实例")
                    def newFlow = createFlowInstance(project, flowDefinition, user, now)
                    //新任务实例，新表单实例
                    println("新任务实例，新表单实例")
                    createTaskInstance(newFlow, newTask, user, now)
                }
            } else {
                //如果不存在，则标记项目完成
                println("如果不存在，则标记项目完成")
                project.taskName = ""
                project.status = 2
            }
        } else if (NodeType.isForkNode(task.taskType)) {
            //这是一个分支节点，找出下一级任务，并逐一处理。
            def tasks = getNextTasks(task.taskId)
            tasks.each {
                processTask(it, project, projectTask, projectFlow, user, now)
            }
        } else if (NodeType.isJoinNode(task.taskType)) {
            //这是一个合并节点，需要检查是否所有的任务都结束，都结束才进行下一个节点。
            //找出那些指向本合并结点的任务
            println("需要检查是否所有的任务都结束")
            def tasks = getPrevTasks(task.taskId)
            println("size is: ${tasks.size()}")
            //检查是否都结束
            if (isAllFinish(projectFlow, tasks)) {
                //如果都己经结束，则找出下一节点并时行处理。
                println("如果都己经结束，则找出下一节点并时行处理")
                def nextTasks = getNextTasks(task.taskId)
                nextTasks.each {
                    processTask(it, project, projectTask, projectFlow, user, now)
                }
            } else {
                //如果没有结束则等待。
                println("流程有任务未结束，等待中。")
            }

        }
    }

    private isAllFinish(ProjectFlow projectFlow, List<WorkTask> workTaskList) {
        def result = true
        workTaskList.each { task ->
            def projectTask = ProjectTask.findByProjectFlowAndTaskId(projectFlow, task.id)
            println("id: ${projectTask.id}, status: ${projectTask.status}")
            if (projectTask.status == 0) {
                result = false
            }
        }
        println("是否都己经结束：${result}")
        result
    }

    private getPrevTasks(String taskId) {
        def transactions = Transaction.findAllByToId(taskId)
        WorkTask.findAllByTaskIdInList(transactions*.fromId)
    }

    private getNextTasks(String taskId) {
        def transactions = Transaction.findAllByFromId(taskId)
        WorkTask.findAllByTaskIdInList(transactions*.toId)
    }

    private getFirstTask(FlowDefinition flowDefinition) {
        //获取start节点
        def startNode = WorkTask.findByFlowDefinitionAndTaskType(flowDefinition, NodeType.start)
        if (startNode == null) return null
        //获取start节点下的流转线
        def transaction = Transaction.findByFlowDefinitionAndFromId(flowDefinition, startNode.taskId)
        if (transaction == null) return null
        //获得流转线下的任务节点
        WorkTask.findByFlowDefinitionAndTaskIdAndTaskType(flowDefinition, transaction.toId, NodeType.task)
    }

    private createTaskInstance(ProjectFlow projectFlow, WorkTask task, SystemUser user, Date date) {
        //生成任务实例
        def projectTask = new ProjectTask()
        projectTask.projectFlow = projectFlow
        projectTask.taskId = task.id
        projectTask.taskName = task.name
        projectTask.taskVersion = task.taskVersion
        projectTask.createUser = user
        projectTask.updateUser = user
        projectTask.createTime = date
        projectTask.updateTime = date
        projectTask.save flush: true

        //生成表单实例
        def formList = TaskForm.findAllByWorkTask(task)
        if (formList) {
            formList.each { form ->
                def data = new ProjectTaskData()
                data.projectTask = projectTask
                data.label = form.labelName
                data.name = form.keyName
                data.type = form.type
                data.save flush: true
            }
        }
    }

    private createFlowInstance(Project project, FlowDefinition flowDefinition, SystemUser user, Date time) {
        //生成流程实例
        def projectFlow = new ProjectFlow()
        projectFlow.project = project
        projectFlow.flowId = flowDefinition.id
        projectFlow.flowName = flowDefinition.name
        projectFlow.flowVersion = flowDefinition.flowVersion
        projectFlow.creator = user
        projectFlow.createTime = time
        projectFlow.updater = user
        projectFlow.updateTime = time
        projectFlow.save flush: true
        projectFlow
    }

}
