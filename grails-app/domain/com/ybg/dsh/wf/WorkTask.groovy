package com.ybg.dsh.wf

class WorkTask {

    static belongsTo = [flowDefinition: FlowDefinition]

    static constraints = {
    }

    String name
    String taskVersion
    Date createTime
    Short flag = 1 as Short
    Long nextId
}
