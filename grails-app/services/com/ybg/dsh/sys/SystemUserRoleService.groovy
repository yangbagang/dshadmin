package com.ybg.dsh.sys

import org.springframework.transaction.annotation.Transactional

@Transactional
class SystemUserRoleService {

    def addUserRole(Long adminId, String[] roleIds) {
        if (adminId && roleIds) {
            for (String roleId in roleIds) {
                if (!SystemUserRole.exists(adminId, Long.valueOf(roleId))) {
                    SystemUserRole.create(adminId, Long.valueOf(roleId))
                }
            }
        }
    }
}
