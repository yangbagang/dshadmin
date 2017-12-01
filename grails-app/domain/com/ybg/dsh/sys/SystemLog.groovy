package com.ybg.dsh.sys

import grails.databinding.BindingFormat

class SystemLog {

    /**操作人*/
    String operator
    /**操作时间*/
    @BindingFormat("yyyy-MM-dd HH:mm:ss")
    Date operationDate
    /**操作内容*/
    String operationMark
    /**操作IP*/
    String loginIp
    /**备注*/
    String remark
    /**类型*/
    String type

    static constraints = {
        operator nullable: false, blank: false
        operationDate nullable: false, blank: false
        operationMark    nullable: false
        loginIp nullable: true
        remark nullable: true
        type nullable: true
    }
}
