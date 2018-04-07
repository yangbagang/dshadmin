package com.ybg.dsh.pm

import com.ybg.dsh.vo.AjaxPagingVo
import com.ybg.dsh.wf.WorkTask
import grails.converters.JSON

class ProjectTaskDataController {

    def projectTaskDataService
    def projectTaskDataIndexService

    def index() {

    }

    def show(Long taskId) {
        def projectTask = ProjectTask.read(taskId)
        //列出某任务需要的全部表单
        def list = ProjectTaskData.findAllByProjectTask(projectTask)
        [taskId: taskId, list: list]
    }

    def show2(String taskId, Long projectId) {
        println("show2")
        def workTask = WorkTask.findByTaskId(taskId)
        def project = Project.get(projectId)
        def projectFlow = ProjectFlow.findByProject(project)
        def projectTask = ProjectTask.findByProjectFlowAndTaskId(projectFlow, workTask.id)
        //列出某任务需要的全部表单
        def list = ProjectTaskData.findAllByProjectTask(projectTask)
        [taskId: projectTask.id, projectId: project.id, list: list]
    }

    def createFile(Long taskId) {
        def projectTask = ProjectTask.read(taskId)
        def dataIndex = projectTaskDataIndexService.getLastIndex(projectTask, "file")
        def data = new ProjectTaskData()
        data.projectTask = projectTask
        data.type = "file"
        data.name = "file_${dataIndex}"
        data.label = "文件_${dataIndex}"
        data.save flush: true
        render data as JSON
    }

    def createText(Long taskId) {
        def projectTask = ProjectTask.read(taskId)
        def dataIndex = projectTaskDataIndexService.getLastIndex(projectTask, "text")
        def data = new ProjectTaskData()
        data.projectTask = projectTask
        data.type = "text"
        data.name = "text_${dataIndex}"
        data.label = "文本_${dataIndex}"
        data.save flush: true
        render data as JSON
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

    def remove(Long id) {
        def data = ProjectTaskData.get(id)
        //data?.delete flush: true

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
