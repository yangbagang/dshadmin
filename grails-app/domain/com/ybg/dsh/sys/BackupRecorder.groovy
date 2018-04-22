package com.ybg.dsh.sys

import grails.databinding.BindingFormat

class BackupRecorder {

    /**操作人*/
    String operator
    /**操作时间*/
    @BindingFormat("yyyy-MM-dd HH:mm:ss")
    Date operationDate
    /**操作IP*/
    String ip
    /**类型*/
    String type
    String fileName
    String fid = ""//编码后的id，方便下载用

    static constraints = {
        operator nullable: false, blank: false
        operationDate nullable: false, blank: false
        ip nullable: true
        type nullable: true
        fileName nullable: false
    }

}
