package com.ybg.dsh.sys

import grails.databinding.BindingFormat
import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class SystemUser implements Serializable {

    transient springSecurityService

    /** 用户名*/
    String username
    String realName
    /** 密码*/
    String password
    /** 是否启用：默认启用*/
    boolean enabled = true
    /** 登录账号是否过期,默认不过期 */
    boolean accountExpired
    /** 登录账号是否锁定,默认不锁定 */
    boolean accountLocked
    /** 登录密码是否过期,默认不过期 */
    boolean passwordExpired
    /** 电子邮件*/
    String email
    /** 创建时间*/
    @BindingFormat("yyyy-MM-dd HH:mm:ss")
    Date createTime
    /** 更新时间*/
    @BindingFormat("yyyy-MM-dd HH:mm:ss")
    Date updateTime
    /** 头像*/
    String avatarUrl
    /**
     * 创建人
     */
    String createUser
    /**
     * 修改人
     */
    String updateUser

    /**
     * #systemUser SystemRoles 系统用户角色关联实体
     */
    static hasMany = [
            systemUserRoles: SystemUserRole
    ]

    Set<SystemRole> getAuthorities() {
        SystemUserRole.findAllByUser(this)*.role
    }

    def beforeInsert() {
        encodePassword()
    }

    def beforeUpdate() {
        if (isDirty('password')) {
            encodePassword()
        }
    }

    protected void encodePassword() {
        password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
    }

    static transients = ['springSecurityService']

    static constraints = {
        username blank: false, unique: true
        realName blank: false
        password blank: false
        email    nullable: true ,email: true, unique: true
        createTime nullable: true
        updateTime nullable: true
        avatarUrl nullable: true
        updateUser nullable: true
        createUser nullable: true
    }

}
