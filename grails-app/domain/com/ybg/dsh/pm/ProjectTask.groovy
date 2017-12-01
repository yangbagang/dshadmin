package com.ybg.dsh.pm

class ProjectTask {

    static belongsTo = [projectFlow: ProjectFlow]

    static constraints = {
    }

    String taskName
    String taskVersion
    Date createTime
    Date updateTime
    Short status = 1 as Short
    String taskTemplate

}
