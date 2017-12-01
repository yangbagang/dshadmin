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
    Date updateTime
    Integer status
    Short flag = 1 as Short
}
