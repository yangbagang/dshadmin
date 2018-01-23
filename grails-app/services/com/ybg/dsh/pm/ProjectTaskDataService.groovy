package com.ybg.dsh.pm

import grails.gorm.transactions.Transactional

@Transactional
class ProjectTaskDataService {

    def updateValue(Long id, String value) {
        def data = ProjectTaskData.get(id)
        if (data) {
            data.value = value
            data.createTime = new Date()
            data.save flush: true
        }
    }

    def updateFileValue(Long id, String value, Long fileSize, String fileName, String fileType) {
        def data = ProjectTaskData.get(id)
        if (data) {
            data.value = value
            data.fileSize = fileSize
            data.fileName = fileName
            data.fileType = fileType
            data.createTime = new Date()
            data.save flush: true
        }
    }

}
