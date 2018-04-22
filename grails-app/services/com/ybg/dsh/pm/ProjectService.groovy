package com.ybg.dsh.pm

import grails.gorm.transactions.Transactional

@Transactional
class ProjectService {

    def removeInfo(Project project) {
        try {
            //找到项目流
            def projectFlow = ProjectFlow.findByProject(project)
            //如果存在，逐一删除
            if (projectFlow) {
                //找到流程任务节点
                def tasks = ProjectTask.findAllByProjectFlow(projectFlow)
                //处理数据
                tasks.each { task ->
                    //处理任务数据
                    def taskData = ProjectTaskData.findAllByProjectTask(task)
                    taskData.each {
                        it?.delete flush: true
                    }
                    //处理关联数据
                    def dataIndex = ProjectTaskDataIndex.findByProjectTask(task)
                    if (dataIndex) {
                        dataIndex?.delete flush: true
                    }
                    //删除任务节点
                    task?.delete flush: true
                }
                //删除
                projectFlow.delete flush: true
            }
            project?.delete flush: true
        } catch (Exception e) {
            println e.message
        }
    }
}
