package com.ybg.dsh.wf

import com.ybg.dsh.sys.SystemUser

class TaskAssign {

    static belongsTo = [workTask: WorkTask, systemUser: SystemUser]

    static constraints = {
    }

    Short flag = 1 as Short
}
