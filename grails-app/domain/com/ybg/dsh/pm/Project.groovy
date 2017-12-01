package com.ybg.dsh.pm

import com.ybg.dsh.sys.SystemUser

class Project {

    static constraints = {
    }

    String name
    String memo
    Date createTime
    SystemUser creator
    Date updateTime
    Long flowId
    String flowName
    String flowVersion
    String taskName
    String userName
    Integer status
    Short flag = 1 as Short
}
