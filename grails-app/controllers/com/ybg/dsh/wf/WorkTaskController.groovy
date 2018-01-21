package com.ybg.dsh.wf

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON

class WorkTaskController {

    def index() { }

    def list(Long flowId) {
        def flow = FlowDefinition.get(flowId)
        def data = WorkTask.findAllByFlowDefinitionAndTaskTypeAndFlag(flow, "task", 1 as Short)
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

}
