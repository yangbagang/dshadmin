package com.ybg.dsh.pm

import grails.converters.JSON

class ProjectTaskController {

    def springSecurityService

    def projectTaskService

    def index1() { }

    def index2() { }

    /**
     * 列出进行中任务
     * @return
     */
    def list1() {
        def user = springSecurityService.currentUser
        def result = projectTaskService.listTask(user, 1, params)
        render result as JSON
    }

    /**
     * 列出己完成任务
     * @return
     */
    def list2() {
        def user = springSecurityService.currentUser
        def result = projectTaskService.listTask(user, 2, params)
        render result as JSON
    }

    /**
     * 完成任务
     */
    def complete(Long taskId) {
        def result = [:]

        def user = springSecurityService.currentUser
        projectTaskService.complete(user, taskId)

        result.success = true
        result.msg = ""
        render result as JSON
    }

}
