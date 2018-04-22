package com.ybg.dsh.sys

import com.ybg.dsh.utils.NetUtil
import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_SUPER_ADMIN', 'ROLE_SYSTEM_ADMIN'])
class BackupRecorderController {

    def backupRecorderService

    def springSecurityService

    def index() {

    }

    def list() {
        def data = BackupRecorder.list(params)
        def count = BackupRecorder.count()

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = count
        result.recordsFiltered = count
        render result as JSON
    }

    def delete(Long id) {
        def result = [:]
        if (id == null) {
            result.success = false
            result.msg = "project is null."
            render result as JSON
            return
        }

        backupRecorderService.delete(id)

        result.success = true
        result.msg = ""
        render result as JSON
    }

    def createDBBackup() {
        def result = [:]
        def user = springSecurityService.currentUser
        def ip = NetUtil.getUserIP(request)
        backupRecorderService.createDBBackup("${user.username}", ip)

        result.success = true
        result.msg = ""
        render result as JSON
    }

    def createFileBackup() {
        def result = [:]
        def user = springSecurityService.currentUser
        def ip = NetUtil.getUserIP(request)
        backupRecorderService.createFileBackup("${user.username}", ip)

        result.success = true
        result.msg = ""
        render result as JSON
    }

}
