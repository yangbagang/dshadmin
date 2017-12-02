package com.ybg.dsh.wf

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON
import org.apache.commons.lang.StringUtils
import org.springframework.transaction.annotation.Transactional

import java.text.SimpleDateFormat

@Transactional(readOnly = true)
class WorkFlowController {

    static allowedMethods = [save: "POST", delete: "DELETE"]

    static sdf = new SimpleDateFormat("yyyyMMddHHmmss")

    def index() {
        //render html for ajax
    }

    def list() {
        def data = WorkFlow.list(params)
        def count = WorkFlow.count()

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = count
        result.recordsFiltered = count
        render result as JSON
    }

    def show(WorkFlow workFlow) {
        render workFlow as JSON
    }

    @Transactional
    def save(WorkFlow workFlow) {
        def result = [:]
        if (workFlow == null) {
            result.success = false
            result.msg = "workFlow is null."
            render result as JSON
            return
        }

        if (StringUtils.isBlank(workFlow.name)) {
            result.success = false
            result.msg = "流程名称不能为空。"
            render result as JSON
            return
        }

        def now = new Date()
        if (!workFlow.id) {
            workFlow.createTime = now
            workFlow.flowVersion = sdf.format(now)
            workFlow.save flush:true
        } else {
            def newWorkFlow = new WorkFlow()
            newWorkFlow.name = workFlow.name
            newWorkFlow.createTime = now
            newWorkFlow.flowVersion = sdf.format(now)
            newWorkFlow.save flush:true

            workFlow.flag = 0 as Short
            workFlow.save flush: true
        }

        result.success = true
        result.msg = ""
        render result as JSON
    }

    @Transactional
    def delete(WorkFlow workFlow) {
        def result = [:]
        if (workFlow == null) {
            result.success = false
            result.msg = "workFlow is null."
            render result as JSON
            return
        }

        workFlow.isDeleted = 1 as Short
        workFlow.save flush:true

        result.success = true
        result.msg = ""
        render result as JSON
    }

}
