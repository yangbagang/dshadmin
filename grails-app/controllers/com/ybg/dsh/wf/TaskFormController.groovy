package com.ybg.dsh.wf

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON
import org.springframework.transaction.annotation.Transactional

class TaskFormController {

    def list(Long taskId) {
        def task = WorkTask.get(taskId)
        def data = TaskForm.findAllByWorkTask(task)
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

    def show(TaskForm taskForm) {
        render taskForm as JSON
    }

    @Transactional
    def save(TaskForm taskForm) {
        def result = [:]
        if (taskForm == null) {
            result.success = false
            result.msg = "taskForm is null."
            render result as JSON
            return
        }

        if (taskForm.hasErrors()) {
            transactionStatus.setRollbackOnly()
            result.success = false
            result.msg = taskForm.errors
            render result as JSON
            return
        }

        taskForm.save flush:true

        result.success = true
        result.msg = ""
        render result as JSON
    }

    @Transactional
    def delete(TaskForm taskForm) {
        def result = [:]
        if (taskForm == null) {
            result.success = false
            result.msg = "taskForm is null."
            render result as JSON
            return
        }

        taskForm.delete flush: true

        result.success = true
        result.msg = ""
        render result as JSON
    }

}
