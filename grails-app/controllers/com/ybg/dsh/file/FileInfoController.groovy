package com.ybg.dsh.file

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON
import org.springframework.transaction.annotation.Transactional

@Transactional(readOnly = true)
class FileInfoController {

    static allowedMethods = [save: "POST", delete: "DELETE"]

    def index() {
        //render html for ajax
    }

    def list() {
        def c = FileInfo.createCriteria()
        def name = params.name ?: ""
        def data = c.list(params) {
            or {
                ilike("title", "%"+name+"%")
                ilike("memo", "%"+name+"%")
                ilike("fileName", "%"+name+"%")
            }
            order("createTime", "desc")
        }

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = data.totalCount
        result.recordsFiltered = data.size()
        render result as JSON
    }

    def show(FileInfo fileInfo) {
        render fileInfo as JSON
    }

    @Transactional
    def save(FileInfo fileInfo) {
        def result = [:]
        if (fileInfo == null) {
            result.success = false
            result.msg = "fileInfo is null."
            render result as JSON
            return
        }

        if (fileInfo.hasErrors()) {
            transactionStatus.setRollbackOnly()
            result.success = false
            result.msg = fileInfo.errors
            render result as JSON
            return
        }

        fileInfo.save flush:true

        result.success = true
        result.msg = ""
        render result as JSON
    }

    @Transactional
    def delete(FileInfo fileInfo) {
        def result = [:]
        if (fileInfo == null) {
            result.success = false
            result.msg = "fileInfo is null."
            render result as JSON
            return
        }

        fileInfo.flag = 0 as Short
        fileInfo.save flush:true

        result.success = true
        result.msg = ""
        render result as JSON
    }

}
