package com.ybg.dsh.pm

import com.ybg.dsh.sys.SystemUser

class Project {

    static constraints = {
        createUser nullable: true
        updateUser nullable: true
    }

    String name = ""
    String memo = ""
    Date createTime = new Date()
    SystemUser createUser
    Date updateTime = new Date()
    SystemUser updateUser
    Long workFlowId = 0L
    Long flowId = 0L
    String flowName = ""
    String flowVersion = ""
    String taskName = "待启动"
    Integer status = 0//0未启动1进行中2己完成9己中止

}
