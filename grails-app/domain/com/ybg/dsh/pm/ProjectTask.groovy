package com.ybg.dsh.pm

import com.ybg.dsh.sys.SystemUser

class ProjectTask {

    static belongsTo = [projectFlow: ProjectFlow]

    static constraints = {
        updateTime nullable: true
    }

    Long taskId
    String taskName
    String taskVersion
    Date createTime = new Date()
    SystemUser createUser
    Date updateTime = new Date()
    SystemUser updateUser
    Integer status = 0//0进行中1己完结2己中止

}
