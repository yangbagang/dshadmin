package com.ybg.dsh.pm

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON
import org.springframework.transaction.annotation.Transactional

@Transactional(readOnly = true)
class ProjectController {

    static allowedMethods = [save: "POST", delete: "DELETE"]

    def springSecurityService

    def index() {
        //render html for ajax
    }

    def list() {
        def data = Project.list(params)
        def count = Project.count()

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = count
        result.recordsFiltered = count
        render result as JSON
    }

    def show(Project project) {
        render project as JSON
    }

    @Transactional
    def save(Project project) {
        def result = [:]
        if (project == null) {
            result.success = false
            result.msg = "project is null."
            render result as JSON
            return
        }

        def user = springSecurityService.currentUser
        if (!project.id) {
            def now = new Date()
            project.createTime = now
            project.updateTime = now
            project.createUser = user
            project.updateUser = user
        } else {
            project.updateTime = new Date()
            project.updateUser = user
        }

        if (project.hasErrors()) {
            transactionStatus.setRollbackOnly()
            result.success = false
            result.msg = project.errors
            render result as JSON
            return
        }

        project.save flush:true

        result.success = true
        result.msg = ""
        render result as JSON
    }

    @Transactional
    def delete(Project project) {
        def result = [:]
        if (project == null) {
            result.success = false
            result.msg = "project is null."
            render result as JSON
            return
        }

        project.flag = 0 as Short
        project.save flush:true

        result.success = true
        result.msg = ""
        render result as JSON
    }

}
