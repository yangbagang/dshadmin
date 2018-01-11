package com.ybg.dsh.wf

class TaskForm {

    static belongsTo = [workTask: WorkTask]

    static constraints = {
    }

    String keyName
    String labelName
    String type
    Integer isHidden = 0
    Integer isBlank = 0

}
