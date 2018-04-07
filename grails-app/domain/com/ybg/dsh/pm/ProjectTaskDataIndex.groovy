package com.ybg.dsh.pm

class ProjectTaskDataIndex {

    static belongsTo = [projectTask: ProjectTask]

    static constraints = {
    }

    String type = ""
    Integer lastIndex = 0

}
