package com.ybg.dsh.wf

class TaskForm {

    static belongsTo = [workTask: WorkTask]

    static constraints = {
    }

    String templateFile
}
