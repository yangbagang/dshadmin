package com.ybg.dsh.wf

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON

class FlowDefinitionController {

    def index() { }

    def list() {
        def data = FlowDefinition.list(params)
        def count = FlowDefinition.count()

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = count
        result.recordsFiltered = count
        render result as JSON
    }

    def design(Long flowId) {

    }

    def save(Long flowId, String context) {

    }

}
