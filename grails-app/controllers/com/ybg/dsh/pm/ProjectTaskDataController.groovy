package com.ybg.dsh.pm

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON

class ProjectTaskDataController {

    def projectTaskDataService

    def index() {

    }

    def show(Long taskId) {
        def projectTask = ProjectTask.read(taskId)
        //列出某任务需要的全部表单
        def list = ProjectTaskData.findAllByProjectTask(projectTask)
        [list: list]
    }

    def update(Long id, String value) {
        projectTaskDataService.updateValue(id, value)

        def result = [:]
        result.success = true
        result.msg = ""
        render result as JSON
    }

    def updateFile(Long id, String value, Long fileSize, String fileName, String fileType) {
        projectTaskDataService.updateFileValue(id, value, fileSize, fileName, fileType)

        def result = [:]
        result.success = true
        result.msg = ""
        render result as JSON
    }

    /**
     * 列出所有文件数据
     * @return
     */
    def listFiles() {
        def c = ProjectTaskData.createCriteria()
        def name = params.name ?: ""
        def data = c.list(params) {
            and {
                eq("type", "file")
                gt("fileSize", 0L)
                or {
                    ilike("label", "%"+name+"%")
                    ilike("fileName", "%"+name+"%")
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

}
