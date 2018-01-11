package com.ybg.dsh.pm

import com.ybg.dsh.sys.SystemUser

class Project {

    static constraints = {
    }

    String name
    String memo
    Date createTime
    SystemUser createUser
    Date updateTime
    SystemUser updateUser
    Long flowId
    String flowName
    String flowVersion
    String taskName
    String userName
    Integer status = 0//0进行中1己完结2己中止
    Short flag = 1 as Short
}
