package com.ybg.dsh.sys

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import org.springframework.transaction.annotation.Transactional

@Transactional(readOnly = true)
@Secured(['ROLE_SUPER_ADMIN', 'ROLE_SYSTEM_ADMIN'])
class SystemRoleController {

    static allowedMethods = [save: "POST", delete: "DELETE"]

    def springSecurityService

    def index() {
        //render html for ajax
    }

    def list() {
        def data = SystemRole.list(params)
        def count = SystemRole.count()

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = count
        result.recordsFiltered = count
        render result as JSON
    }

    def show(SystemRole systemRole) {
        render systemRole as JSON
    }

    @Transactional
    def save(SystemRole systemRole) {
        def result = [:]
        if (systemRole == null) {
            result.success = false
            result.msg = "systemRole is null."
            render result as JSON
            return
        }

        def user = springSecurityService.currentUser
        if (!systemRole.id) {
            def now = new Date()
            systemRole.createTime = now
            systemRole.updateTime = now
            systemRole.createUser = user.realName
            systemRole.updateUser = user.realName
        } else {
            systemRole.updateTime = new Date()
            systemRole.updateUser = user.realName
        }

        if (systemRole.hasErrors()) {
            transactionStatus.setRollbackOnly()
            result.success = false
            result.msg = systemRole.errors
            render result as JSON
            return
        }

        systemRole.save flush:true

        result.success = true
        result.msg = ""
        render result as JSON
    }

    @Transactional
    def delete(SystemRole systemRole) {
        def result = [:]
        if (systemRole == null) {
            result.success = false
            result.msg = "systemRole is null."
            render result as JSON
            return
        }

        systemRole.delete flush:true

        result.success = true
        result.msg = ""
        render result as JSON
    }

}
