package com.ybg.dsh.wf

class FlowDefinition {

    static belongsTo = [workFlow: WorkFlow]

    static constraints = {
    }

    String name
    String flowVersion
    Date createTime
    Short flag = 1 as Short
    String context
    Long prevId = 0L
}
