package com.ybg.dsh.wf

import com.ybg.dsh.sys.SystemUser
import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON
import org.springframework.transaction.annotation.Transactional

class TaskAssignController {

    def list(Long taskId) {
        def task = WorkTask.get(taskId)
        def data = TaskAssign.findAllByWorkTaskAndFlag(task, 1 as Short)
        def count = data.size()

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = count
        result.recordsFiltered = count
        render result as JSON
    }

    @Transactional
    def save(Long taskId, Long userId) {
        def result = [:]
        def task = WorkTask.get(taskId)
        def user = SystemUser.get(userId)
        def assign = TaskAssign.findByWorkTaskAndSystemUser(task, user)
        if (assign) {
            //己经存在
            result.success = false
            result.msg = "设定己经存在"
        } else {
            //新建
            assign = new TaskAssign()
            assign.systemUser = user
            assign.workTask = task
            assign.save flush: true

            result.success = true
            result.msg = ""
        }
        render result as JSON
    }

    @Transactional
    def delete(TaskAssign taskAssign) {
        def result = [:]
        if (taskAssign == null) {
            result.success = false
            result.msg = "taskAssign is null."
            render result as JSON
            return
        }

        taskAssign.flag = 0 as Short
        taskAssign.save flush:true

        result.success = true
        result.msg = ""
        render result as JSON
    }

    def listUsers() {
        def list = []
        def users = SystemUser.findAllByEnabled(true)
        users.each { user ->
            def map = [:]
            map.userId = user.id
            map.userName = user.realName
            list.add(map)
        }

        render list as JSON
    }

}
