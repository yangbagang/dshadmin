package com.ybg.dsh.pm

import com.ybg.dsh.vo.AjaxPagingVo
import grails.converters.JSON
import org.springframework.transaction.annotation.Transactional

@Transactional(readOnly = true)
class ProjectController {

    static allowedMethods = [save: "POST", delete: "DELETE"]

    def springSecurityService

    def projectFlowService

    def index() {
        //默认首页
        //render html for ajax
    }

    def index2() {
        //进行中
        //render html for ajax
    }

    def index3() {
        //己完成
        //render html for ajax
    }

    def index4() {
        //未启动
    }

    /**
     * 列出所有项目
     * @return
     */
    def list() {
        def c = Project.createCriteria()
        def name = params.name ?: ""
        def data = c.list(params) {
            and {
                eq("flag", 1 as Short)
                or {
                    ilike("name", "%"+name+"%")
                    ilike("memo", "%"+name+"%")
                }
            }
            order("createTime", "desc")
        }

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = data.totalCount
        result.recordsFiltered = data.size()
        render result as JSON
    }

    /**
     * 只列出进行中项目
     * @return
     */
    def list2() {
        def c = Project.createCriteria()
        def name = params.name ?: ""
        def data = c.list(params) {
            and {
                eq("status", 1)
                or {
                    ilike("name", "%"+name+"%")
                    ilike("memo", "%"+name+"%")
                }
            }
            order("createTime", "desc")
        }

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = data.totalCount
        result.recordsFiltered = data.size()
        render result as JSON
    }

    /**
     * 只列出己完成项目
     * @return
     */
    def list3() {
        def c = Project.createCriteria()
        def name = params.name ?: ""
        def data = c.list(params) {
            and {
                eq("status", 2)
                or {
                    ilike("name", "%"+name+"%")
                    ilike("memo", "%"+name+"%")
                }
            }
            order("createTime", "desc")
        }

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = data.totalCount
        result.recordsFiltered = data.size()
        render result as JSON
    }

    /**
     * 只列出未启动项目
     * @return
     */
    def list4() {
        def c = Project.createCriteria()
        def name = params.name ?: ""
        def data = c.list(params) {
            and {
                eq("status", 0)
                or {
                    ilike("name", "%"+name+"%")
                    ilike("memo", "%"+name+"%")
                }
            }
            order("createTime", "desc")
        }

        def result = new AjaxPagingVo()
        result.data = data
        result.draw = Integer.valueOf(params.draw)
        result.error = ""
        result.success = true
        result.recordsTotal = data.totalCount
        result.recordsFiltered = data.size()
        render result as JSON
    }

    def show(Project project) {
        render project as JSON
    }

    @Transactional
    def save(Project project) {
        def result = [:]
        if (project == null) {
            result.success = false
            result.msg = "project is null."
            render result as JSON
            return
        }

        def user = springSecurityService.currentUser
        if (!project.id) {
            def now = new Date()
            project.createTime = now
            project.updateTime = now
            project.createUser = user
            project.updateUser = user
        } else {
            project.updateTime = new Date()
            project.updateUser = user
        }

        if (project.hasErrors()) {
            transactionStatus.setRollbackOnly()
            result.success = false
            result.msg = project.errors
            render result as JSON
            return
        }

        project.save flush:true

        result.success = true
        result.msg = ""
        render result as JSON
    }

    /**
     * 中止流程
     * @param project
     * @return
     */
    def delete(Project project) {
        def result = [:]
        if (project == null) {
            result.success = false
            result.msg = "project is null."
            render result as JSON
            return
        }

        if (project.status == 2) {
            result.success = false
            result.msg = "项目己完成，无法中止。"
            render result as JSON
            return
        }

        if (project.status == 9) {
            result.success = false
            result.msg = "项目己中止，无需重复。"
            render result as JSON
            return
        }

        def user = springSecurityService.currentUser
        projectFlowService.stop(user, project)

        result.success = true
        result.msg = ""
        render result as JSON
    }

    /**
     *
     * @param project
     * @return
     */
    def start(Project project) {
        def result = [:]
        if (project == null) {
            result.success = false
            result.msg = "project is null."
            render result as JSON
            return
        }

        if (project.status != 0) {
            result.success = false
            result.msg = "项目不是未启动状态，不能启动。"
            render result as JSON
            return
        }

        def user = springSecurityService.currentUser
        projectFlowService.start(user, project)

        result.success = true
        result.msg = ""
        render result as JSON
    }

}
