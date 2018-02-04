package com.ybg.dsh.enums

class NodeType {

    static start = "start round mix"
    static end = "end round"
    static task = "task"
    static join = "join"
    static fork = "fork"

    /**
     * 检查节点是否是开始节点
     * @param nodeType
     * @return
     */
    static isStartNode(String nodeType) {
        nodeType != null && nodeType.contains("start")
    }

    /**
     * 检查节点是否是任务节点
     * @param nodeType
     * @return
     */
    static isTaskNode(String nodeType) {
        nodeType == task
    }

    /**
     * 检查节点是否是结束节点
     * @param nodeType
     * @return
     */
    static isEndNode(String nodeType) {
        nodeType != null && nodeType.contains("end")
    }

    /**
     * 检查节点是否是合并节点
     * @param nodeType
     * @return
     */
    static isJoinNode(String nodeType) {
        nodeType == join
    }

    /**
     * 检查节点是否是分支节点
     * @param nodeType
     * @return
     */
    static isForkNode(String nodeType) {
        nodeType == fork
    }

}
