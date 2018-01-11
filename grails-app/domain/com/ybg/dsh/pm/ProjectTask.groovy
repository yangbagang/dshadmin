package com.ybg.dsh.pm

class ProjectTask {

    static belongsTo = [projectFlow: ProjectFlow]

    static constraints = {
        updateTime nullable: true
    }

    String taskName
    String taskVersion
    Date createTime = new Date()
    Date updateTime
    Short status = 1 as Short

}
