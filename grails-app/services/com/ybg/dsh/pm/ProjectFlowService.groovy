package com.ybg.dsh.pm

import com.ybg.dsh.enums.NodeType
import com.ybg.dsh.sys.SystemUser
import com.ybg.dsh.wf.FlowDefinition
import com.ybg.dsh.wf.TaskForm
import com.ybg.dsh.wf.Transaction
import com.ybg.dsh.wf.WorkFlow
import com.ybg.dsh.wf.WorkTask
import grails.gorm.transactions.Transactional

@Transactional
class ProjectFlowService {

    def stop(SystemUser user, Project project) {
        if (user == null || project == null) return
        def now = new Date()
        //标记项目为中止
        project.updateUser = user
        project.updateTime = now
        project.status = 9
        project.save flush: true
        //标记项目进行中流程为中止
        def flow = ProjectFlow.findByProjectAndStatus(project, 0)
        if (flow) {
            flow.updater = user
            flow.updateTime = now
            flow.status = 2
            flow.save flush: true
            //标记进行中任务为中止
            def tasks = ProjectTask.findAllByProjectFlowAndStatus(flow, 0)
            if (tasks) {
                tasks.each { task ->
                    task.updateTime = now
                    task.status = 2
                    task.save flush: true
                }
            }
        }
    }

    def start(SystemUser user, Project project) {
        if (user == null || project == null) return
        //准备数据
        def now = new Date()
        //工作流
        def workFlow = WorkFlow.get(project.workFlowId)
        //流程定义
        def flowDefinition = FlowDefinition.findByWorkFlowAndFlagAndPrevId(workFlow, 1 as Short, 0L)
        //第一个任务节点
        def task = getFirstTask(flowDefinition)

        //数据检查
        if (workFlow == null || workFlow.isDeleted == 1 as Short || workFlow.flag == 0 as Short) {
            println("指定工作流不正常")
            return
        }
        if (flowDefinition == null) {
            println("工作流定义不存在")
            return
        }
        if (task == null) {
            println("任务节不存在")
            return
        }

        //补充项止数据并标记状态
        project.flowId = flowDefinition.id
        project.flowName = flowDefinition.name
        project.flowVersion = flowDefinition.flowVersion
        project.taskName = task.name
        project.updateUser = user
        project.updateTime = now
        project.status = 1
        project.save flush: true

        //生成流程实例
        def projectFlow = new ProjectFlow()
        projectFlow.project = project
        projectFlow.flowId = flowDefinition.id
        projectFlow.flowName = flowDefinition.name
        projectFlow.flowVersion = flowDefinition.flowVersion
        projectFlow.creator = user
        projectFlow.createTime = now
        projectFlow.updater = user
        projectFlow.updateTime = now
        projectFlow.save flush: true

        //生成任务实例
        def projectTask = new ProjectTask()
        projectTask.projectFlow = projectFlow
        projectTask.taskId = task.id
        projectTask.taskName = task.name
        projectTask.taskVersion = task.taskVersion
        projectTask.createUser = user
        projectTask.updateUser = user
        projectTask.createTime = now
        projectTask.updateTime = now
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

    def getFirstTask(FlowDefinition flowDefinition) {
        //获取start节点
        def startNode = WorkTask.findByFlowDefinitionAndTaskType(flowDefinition, NodeType.start)
        if (startNode == null) return null
        //获取start节点下的流转线
        def transaction = Transaction.findByFlowDefinitionAndFromId(flowDefinition, startNode.taskId)
        if (transaction == null) return null
        //获得流转线下的任务节点
        WorkTask.findByFlowDefinitionAndTaskIdAndTaskType(flowDefinition, transaction.toId, NodeType.task)
    }

}
