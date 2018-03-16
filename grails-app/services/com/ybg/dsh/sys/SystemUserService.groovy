package com.ybg.dsh.sys

import org.springframework.transaction.annotation.Transactional

/**
 * Created by yangbagang on 16/7/9.
 */
@Transactional
class SystemUserService {

    def initSystemUser() {
        def hasUsers = !SystemUser.listOrderById().empty
        if(!hasUsers) {
            def user = new SystemUser()
            user.username = "ybg"
            user.realName = "ybg"
            user.password = "ybg@2017"
            user.enabled = true
            user.accountExpired = false
            user.accountLocked = false
            user.passwordExpired = false
            user.email = "81667842@qq.com"
            def now = new Date()
            user.createTime = now
            user.updateTime = now
            user.createUser = "system"
            user.updateUser = "system"
            user.avatarUrl = " "
            user.save flush: true

            def role = new SystemRole()
            role.authority = "ROLE_SUPER_ADMIN"
            role.roleName = "超级管理员"
            role.remark = "初始权限，不要修改。"
            role.createTime = now
            role.updateTime = now
            role.createUser = "system"
            role.updateUser = "system"
            role.save flush: true

            def role2 = new SystemRole()
            role2.authority = "ROLE_FILE_ADMIN"
            role2.roleName = "法律法规管理员"
            role2.remark = "管理系统内收入的法律法规，没有该权限将只能下载。"
            role2.createTime = now
            role2.updateTime = now
            role2.createUser = "system"
            role2.updateUser = "system"
            role2.save flush: true

            def role3 = new SystemRole()
            role3.authority = "ROLE_PROJECT_ADMIN"
            role3.roleName = "项目管理员"
            role3.remark = "管理系统内的各项目，没有此权限将只能查看项目信息，不能处理相关事务。"
            role3.createTime = now
            role3.updateTime = now
            role3.createUser = "system"
            role3.updateUser = "system"
            role3.save flush: true

            SystemUserRole.create(user, role)
        }
    }
}
