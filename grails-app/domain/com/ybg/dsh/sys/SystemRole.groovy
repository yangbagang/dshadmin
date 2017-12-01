package com.ybg.dsh.sys

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@EqualsAndHashCode(includes='authority')
@ToString(includes='authority', includeNames=true, includePackage=false)
class SystemRole implements Serializable {

    String authority
    /** 角色名*/
    String roleName
    /** 备注*/
    String remark
    /** 创建时间*/
    Date createTime
    /** 更新时间*/
    Date updateTime
    /**
     * 创建人
     */
    String createUser
    /**
     * 修改人
     */
    String updateUser

    static hasMany = [systemUserRoles: SystemUserRole]

    static constraints = {
        authority blank: false, unique: true
        roleName blank: false, unique: true
        createTime nullable: true
        updateTime nullable: true
        remark nullable: true
        updateUser nullable: true
        createUser nullable: true
    }

}
