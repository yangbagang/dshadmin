package com.ybg.dsh.wf

import com.ybg.dsh.sys.SystemUser
import grails.gorm.transactions.Transactional

@Transactional
class TaskAssignService {

    def assignAll(Long flowId, Long userId) {
        def flow = FlowDefinition.get(flowId)
        def user = SystemUser.get(userId)
        if (flow && user) {
            def tasks = WorkTask.findAllByFlowDefinitionAndTaskType(flow, "task")
            tasks.each { task ->
                def assign = TaskAssign.findByWorkTaskAndSystemUser(task, user)
                if (!assign || assign.flag == 0 as Short) {
                    assign = new TaskAssign()
                    assign.workTask = task
                    assign.systemUser = user
                    assign.save flush: true
                }
            }
        }
    }
}
