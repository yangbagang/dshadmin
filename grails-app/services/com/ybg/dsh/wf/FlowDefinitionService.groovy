package com.ybg.dsh.wf

import grails.gorm.transactions.Transactional
import groovy.json.JsonSlurper

import java.text.SimpleDateFormat

@Transactional
class FlowDefinitionService {

    private static sdf = new SimpleDateFormat("yyyyMMddHHmmss")

    private static emptyContext = "{\"title\":\"流程设计\",\"nodes\":{},\"lines\":{},\"areas\":{},\"initNum\":1}"

    def save(Long id, String name, String memo, Long prevId, Long workFlowId) {
        def workFlow = WorkFlow.read(workFlowId)
        if (!workFlow) return
        if (id) {
            //更新
            def flow = FlowDefinition.get(id)
            if (flow) {
                //创建新版本
                createDefinition(name, memo, flow.context, prevId, workFlow)
                //作废旧版本
                flow.flag = 0 as Short
                flow.save flush: true
            }
        } else {
            //新增
            createDefinition(name, memo, emptyContext, prevId, workFlow)
        }
    }

    def updateContext(Long flowId, String context) {
        def flowDefinition = FlowDefinition.get(flowId)
        if (flowDefinition == null || flowDefinition.flag == 0 as Short) {
            return//无效流程不需要编辑
        }
        //创建新版本流程
        def newFlow = new FlowDefinition()
        newFlow.workFlow = flowDefinition.workFlow
        newFlow.name = flowDefinition.name
        newFlow.memo = flowDefinition.memo
        newFlow.flowVersion = sdf.format(new Date())
        newFlow.context = context
        newFlow.prevId = flowDefinition.prevId
        newFlow.save flush: true
        //作废旧版本
        flowDefinition.flag = 0 as Short
        flowDefinition.save flush: true
        //解析内容
        def jsonSlurper = new JsonSlurper()
        def json = jsonSlurper.parseText(context)
        //节点信息
        def nodes = json.nodes
        //流转信息
        def lines = json.lines
        //保存数据
        saveNodes(nodes, newFlow)
        saveLines(lines, newFlow)

        newFlow.id
    }

    private saveNodes(nodes, flowDefinition) {
        if (!nodes || nodes.size() == 0) return
        def now = new Date()
        nodes.each { node ->
            node.each {
                def taskId = it.key
                def nodeInfo = it.value
                def task = new WorkTask()
                task.flowDefinition = flowDefinition
                task.name = nodeInfo.name
                task.taskVersion = sdf.format(now)
                task.createTime = now
                task.taskId = taskId
                task.taskType = nodeInfo.type
                task.save flush: true
            }
        }
    }

    private saveLines(lines, flowDefinition) {
        if (!lines || lines.size() == 0) return
        def now = new Date()
        lines.each { line ->
            line.each {
                def tranId = it.key
                def tranInfo = it.value
                def transaction = new Transaction()
                transaction.flowDefinition = flowDefinition
                transaction.transId = tranId
                transaction.transType = tranInfo.type
                transaction.fromId = tranInfo.from
                transaction.toId = tranInfo.to
                transaction.name = tranInfo.name
                transaction.dash = tranInfo.dash ? 1 : 0
                transaction.marked = tranInfo.marked ? 1 : 0
                transaction.conditions = ""//条件未实现
                transaction.save flush: true
            }
        }
    }

    private createDefinition(String name, String memo, String context, Long prevId, WorkFlow workFlow) {
        def definition = new FlowDefinition()
        definition.workFlow = workFlow
        definition.name = name
        definition.memo = memo
        definition.flowVersion = sdf.format(new Date())
        definition.context = context
        definition.prevId = prevId
        definition.save flush: true
    }
}
