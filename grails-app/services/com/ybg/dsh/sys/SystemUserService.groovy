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

            SystemUserRole.create(user, role)
        }
    }
}
