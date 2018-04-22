package com.ybg.dsh.sys

import grails.gorm.services.Service
import org.springframework.transaction.annotation.Transactional

import java.text.SimpleDateFormat

@Transactional
class BackupRecorderService {

    private sdf = new SimpleDateFormat("yyyyMMddHHmmss")

    def delete(Long id) {
        def recorder = BackupRecorder.get(id)
        if (recorder) {
            //TODO 物理删除文件
            recorder.delete flush: true
        }
    }

    def createDBBackup(String user, String ip) {
        def instance = createInstance(user, ip, "DB")
        //TODO 实现具体数据库备份
    }

    def createFileBackup(String user, String ip) {
        def instance = createInstance(user, ip, "FILE")
        //TODO 实现具体文件备份
    }

    private createInstance(String operator, String ip, String type) {
        def now = new Date()
        def instance = new BackupRecorder()
        instance.operator = operator
        instance.operationDate = now
        instance.ip = ip
        instance.type = type
        if (type == "DB") {
            instance.fileName = "${sdf.format(now)}.sql"
        } else if (type == "FILE") {
            instance.fileName = "${sdf.format(now)}.zip"
        } else {
            instance.fileName = "${sdf.format(now)}.backup"
        }
        instance.save flush: true

        instance
    }
}