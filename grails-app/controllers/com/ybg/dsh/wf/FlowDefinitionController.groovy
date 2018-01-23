package com.ybg.dsh.wf

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON

class FlowDefinitionController {

    def flowDefinitionService

    def index() {

    }

    def list() {
        def c = FlowDefinition.createCriteria()
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

    def show(FlowDefinition flowDefinition) {
        render flowDefinition as JSON
    }

    def design(Long flowId) {
        def flow = FlowDefinition.read(flowId)
        [flow: flow]
    }

    def viewContext(Long flowId) {
        render FlowDefinition.read(flowId).context
    }

    def save(Long id, String name, String memo, Long prevId, Long workFlowId) {
        def result = [:]

        flowDefinitionService.save(id, name, memo, prevId, workFlowId)

        result.success = true
        result.msg = ""
        render result as JSON
    }

    def update(Long flowId, String context) {
        def result = [:]

        def id = flowDefinitionService.updateContext(flowId, context)

        result.success = true
        result.msg = ""
        result.id = id
        render result as JSON
    }

    /**
     * 流程列表，用于下拉选择
     * @return
     */
    def flowList() {
        def flowList = FlowDefinition.findAllByFlag(1 as Short)
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
