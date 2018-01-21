package com.ybg.dsh.wf

class FlowDefinition {

    static belongsTo = [workFlow: WorkFlow]

    static constraints = {

    }

    static mapping = {
        context column: "context", sqlType: "text"
    }

    String name
    String memo
    String flowVersion
    Date createTime = new Date()
    Short flag = 1 as Short
    String context
    Long prevId = 0L

    transient String prevName

    String getPrevName() {
        read(prevId)?.name ?: ""
    }
}
