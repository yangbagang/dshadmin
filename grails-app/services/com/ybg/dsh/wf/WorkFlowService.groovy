package com.ybg.dsh.wf

import grails.gorm.transactions.Transactional

import java.text.SimpleDateFormat

@Transactional
class WorkFlowService {

    private sdf = new SimpleDateFormat("yyyyMMddHHmmss")

    def save(Long id, String name, String memo) {
        if (id) {
            println("更新实例")
            def oldWorkFlow = WorkFlow.get(id)
            if (oldWorkFlow) {
                //创建新实例
                def newWorkFlow = createInstance(name, memo)
                //变更旧实例
                oldWorkFlow.flag = 0 as Short
                oldWorkFlow.save flush: true
                //将原指旧版本的引用指向新版本
                def flowList = FlowDefinition.findAllByWorkFlow(oldWorkFlow)
                flowList.each { flow->
                    flow.workFlow = newWorkFlow
                    flow.save flush: true
                }
            }
        } else {
            //创建新实例
            println("创建新实例")
            createInstance(name, memo)
        }
    }

    private createInstance(String name, String memo) {
        def instance = new WorkFlow()
        def now = new Date()
        instance.name = name
        instance.memo = memo
        instance.createTime = now
        instance.flowVersion = sdf.format(now)
        instance.save flush: true
        instance
    }

}
