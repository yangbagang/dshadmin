package com.ybg.dsh.wf

class WorkFlow {

    static constraints = {
    }

    String name
    String flowVersion
    Date createTime
    Short flag = 1 as Short
    Short isDeleted = 0 as Short
}
