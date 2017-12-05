package com.ybg.dsh.pm

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON

class ProjectTaskController {

    def index1() { }

    def index2() { }

    def list() {
        def data = ProjectTask.list(params)
        def count = ProjectTask.count()

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
