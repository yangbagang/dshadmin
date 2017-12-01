package com.ybg.dsh.sys

import grails.gorm.DetachedCriteria
import groovy.transform.ToString
import org.apache.commons.lang.builder.HashCodeBuilder

@ToString(cache=true, includeNames=true, includePackage=false)
class SystemUserRole implements Serializable {

    SystemUser user
    SystemRole role

    @Override
    boolean equals(other) {
        if (other instanceof SystemUserRole) {
            other.userId == user?.id && other.roleId == role?.id
        }
    }

    @Override
    int hashCode() {
        def builder = new HashCodeBuilder()
        if (user) builder.append(user.id)
        if (role) builder.append(role.id)
        builder.toHashCode()
    }

    static SystemUserRole get(long userId, long roleId) {
        criteriaFor(userId, roleId).get()
    }

    static boolean exists(long userId, long roleId) {
        criteriaFor(userId, roleId).count()
    }

    private static DetachedCriteria criteriaFor(long userId, long roleId) {
        SystemUserRole.where {
            user == SystemUser.load(userId) &&
                    role == SystemRole.load(roleId)
        }
    }

    static SystemUserRole create(SystemUser user, SystemRole role) {
        def instance = new SystemUserRole(user: user, role: role)
        instance.save()
        instance
    }

    static SystemUserRole create(Long userId, Long roleId) {
        def user = SystemUser.get(userId)
        def role = SystemRole.get(roleId)
        if (user && role) {
            def instance = new SystemUserRole(user: user, role: role)
            instance.save(flush: true)
            instance
        }
    }

    static boolean remove(SystemUser u, SystemRole r) {
        if (u != null && r != null) {
            SystemUserRole.where { user == u && role == r }.deleteAll()
        }
    }

    static int removeAll(SystemUser u) {
        u == null ? 0 : SystemUserRole.where { user == u }.deleteAll()
    }

    static int removeAll(SystemRole r) {
        r == null ? 0 : SystemUserRole.where { role == r }.deleteAll()
    }

    static constraints = {
        role validator: { SystemRole r, SystemUserRole ur ->
            if (ur.user?.id) {
                SystemUserRole.withNewSession {
                    if (SystemUserRole.exists(ur.user.id, r.id)) {
                        return ['userRole.exists']
                    }
                }
            }
        }
    }

    static mapping = {
        id composite: ['user', 'role']
        version false
    }
}
