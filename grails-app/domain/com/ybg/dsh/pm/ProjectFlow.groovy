package com.ybg.dsh.pm

import com.ybg.dsh.sys.SystemUser

class ProjectFlow {

    static belongsTo = [project: Project]

    static constraints = {
    }

    Long flowId
    String flowName
    String flowVersion
    SystemUser creator
    Date createTime
    SystemUser updater
    Date updateTime
    Integer status = 0//0进行中1己完结2己中止

}
