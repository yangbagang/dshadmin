package com.ybg.dsh.pm

import grails.gorm.transactions.Transactional

@Transactional
class ProjectTaskDataIndexService {

    def getLastIndex(ProjectTask projectTask, String type) {
        def dataIndex = ProjectTaskDataIndex.findByProjectTaskAndType(projectTask, type)
        if (!dataIndex) {
            dataIndex = new ProjectTaskDataIndex()
            dataIndex.projectTask = projectTask
            dataIndex.type = type
            dataIndex.lastIndex = 1
            dataIndex.save flush: true
            return 1
        }
        dataIndex.lastIndex += 1
        dataIndex.save flush: true
        return dataIndex.lastIndex
    }

}
