package com.ybg.dsh.wf

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON
import org.apache.commons.lang.StringUtils
import org.springframework.transaction.annotation.Transactional

import java.text.SimpleDateFormat

@Transactional(readOnly = true)
class WorkFlowController {

    static allowedMethods = [save: "POST", delete: "DELETE"]

    def workFlowService

    def index() {
        //render html for ajax
    }

    def list() {
        def c = WorkFlow.createCriteria()
        def name = params.name ?: ""
        def data = c.list(params) {
            and {
                eq("flag", 1 as Short)
                or {
                    ilike("name", "%"+name+"%")
                    ilike("memo", "%"+name+"%")
                }
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

    def show(WorkFlow workFlow) {
        render workFlow as JSON
    }

    def save(Long id, String name, String memo) {
        def result = [:]

        if (StringUtils.isBlank(name)) {
            result.success = false
            result.msg = "流程名称不能为空。"
            render result as JSON
            return
        }

        workFlowService.save(id, name, memo)

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

    /**
     * 流程列表，用于下拉选择
     * @return
     */
    def flowList() {
        def flowList = WorkFlow.findAllByFlagAndIsDeleted(1 as Short, 0 as Short)
        def result = []
        flowList.each { flow ->
            def map = [:]
            map.flowId = flow.id
            map.flowName = flow.name
            result.add(map)
        }
        render result as JSON
    }

}
