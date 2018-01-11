package com.ybg.dsh.wf

class Transaction {

    static belongsTo = [flowDefinition: FlowDefinition]

    static constraints = {
    }

    String transId
    String transType
    String fromId
    String toId
    String name
    Integer dash = 0
    Integer marked = 0
    String condition = ""
}
