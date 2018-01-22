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
        def c = Project.createCriteria()
        def taskIdList = TaskAssign.findAllBySystemUser(user)*.workTask*.id
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
    }

    def complete(SystemUser user, Long taskId) {
        def now = new Date()
        def projectTask = ProjectTask.get(taskId)
        if (projectTask == null) return

        //标记当前任务为完成状态
        projectTask.updateTime = now
        projectTask.updateUser = user
        projectTask.status = 2
        projectTask.save flush: true

        def projectFlow = projectTask.projectFlow
        def project = projectFlow.project

        //获取下一任务
        def tasks = getNextTasks(WorkTask.get(projectTask.taskId).taskId)
        if (tasks == null || tasks.isEmpty()) return

        //公共内容
        project.taskName = ""
        project.updateUser = user
        project.updateTime = now
        projectFlow.updater = user
        projectFlow.updateTime = now

        //任务处理
        tasks.each { task ->
            //如果下一任务不是结束任务
            if (task.taskType == NodeType.task) {
                //将项目指向下一任务
                project.taskName += "${task.name} "
                //创建新任务实例，创建新表单实例
                createTaskInstance(projectFlow, task, user, now)
            } else if (task.taskType == NodeType.end) {
                //如果下一任务是结束任务
                //标记流程完成
                projectFlow.status = 1
                //查找下一流程
                def flowDefinition = FlowDefinition.findByPrevId(projectFlow.flowId)
                if (flowDefinition) {
                    //如果存在，取得下一流程的第一个任务节点
                    def newTask = getFirstTask(flowDefinition)
                    if (newTask) {
                        //则将项目指向下一流程
                        project.flowId = flowDefinition.id
                        project.flowName = flowDefinition.name
                        project.flowVersion = flowDefinition.flowVersion
                        project.taskName = newTask.name
                        //创建新流程实例
                        def newFlow = createFlowInstance(project, flowDefinition, user, now)
                        //新任务实例，新表单实例
                        createTaskInstance(newFlow, newTask, user, now)
                    }
                } else {
                    //如果不存在，则标记项目完成
                    project.status = 2
                }
            }
        }

        //保存数据
        projectFlow.save flush: true
        project.save flush: true
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
