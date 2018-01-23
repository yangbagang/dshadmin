package com.ybg.dsh.pm

class ProjectTaskData {

    static belongsTo = [projectTask: ProjectTask]

    static constraints = {
    }

    String label = ""
    String name = ""
    String type = ""
    String value = ""
    Long fileSize = 0L
    String fileName = ""
    String fileType = ""
    Date createTime = new Date()//更新时间
}
