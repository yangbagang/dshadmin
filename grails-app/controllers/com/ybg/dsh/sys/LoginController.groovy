package com.ybg.dsh.sys

import com.ybg.dsh.utils.NetUtil
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.authentication.encoding.BCryptPasswordEncoder
import grails.plugin.springsecurity.userdetails.NoStackUsernameNotFoundException
import org.apache.commons.lang.StringUtils
import org.springframework.security.core.context.SecurityContextHolder

class LoginController {

    /** spring 安全服务类*/
    def springSecurityService

    def jcaptchaService

    def systemUserCaptchaLimitService

    def systemLogService

    def index() {
        render(view: "login")
    }

    def form() {
        render(view: "login")
    }

    def validateAuthUser(SystemUser systemUserInstance) {
        def crypto = new BCryptPasswordEncoder(
                (int) SpringSecurityUtils.securityConfig.password.bcrypt.logrounds)
        def systemUser = SystemUser.findByUsernameAndEnabled(systemUserInstance.username, true)
        if (systemUser == null ||
                !crypto.isPasswordValid(systemUser.password, systemUserInstance.password, null)) {
            throw new NoStackUsernameNotFoundException()
        }
    }

    def authFail() {
        flash.message = "登录失败,用户不存在或密码错。"
        redirect url: SpringSecurityUtils.securityConfig.auth.loginFormUrl
    }

    //登录处理
    def auth(SystemUser systemUserInstance) {
        if (springSecurityService == null) {
            println("springSecurityService is null: in controller")
        }
        ConfigObject jcaptcha = grailsApplication.config.jcaptcha
        if (jcaptcha.enabled) {
            if (!params.jcaptchaChallenge) {
                session.setAttribute(SpringSecurityUtils.SPRING_SECURITY_LAST_USERNAME_KEY, systemUserInstance.username)
                session.setAttribute('SPRING_SECURITY_LAST_PASSWORD', systemUserInstance.password)
                flash.message = "登录失败,验证码不能为空。"
                flash.errorTag = 1
                redirect url: SpringSecurityUtils.securityConfig.auth.loginFormUrl
                return
            }
            def jcaptchaName = jcaptcha.jcaptchaName as String
            if (!jcaptchaService.validateResponse(jcaptchaName,
                    session.id, params.jcaptchaChallenge)) {
                session.setAttribute(SpringSecurityUtils.SPRING_SECURITY_LAST_USERNAME_KEY, systemUserInstance.username)
                session.setAttribute('SPRING_SECURITY_LAST_PASSWORD', systemUserInstance.password)
                if (systemUserCaptchaLimitService.failLogin(jcaptchaName)) {
                    flash.message = "登录失败,超过最大允许次数。"
                    redirect url: SpringSecurityUtils.securityConfig.auth.loginFormUrl
                    return
                }
                flash.message = "验证码错误。"
                flash.errorTag = 1
                redirect url: SpringSecurityUtils.securityConfig.auth.loginFormUrl
                return
            }
            systemUserCaptchaLimitService.loginSuccess(jcaptchaName)
        }
        springSecurityService.clearCachedRequestmaps()
        if (StringUtils.isEmpty(systemUserInstance.username) ||
                StringUtils.isEmpty(systemUserInstance.password)) {
            session.setAttribute(SpringSecurityUtils.SPRING_SECURITY_LAST_USERNAME_KEY, '')
            session.setAttribute('SPRING_SECURITY_LAST_PASSWORD', '')
            flash.message = "用户名、密码不能为空。"
            flash.errorTag = 2
            redirect url: SpringSecurityUtils.securityConfig.auth.loginFormUrl
            return
        }
        if (!springSecurityService.isLoggedIn()) {
            try {
                validateAuthUser(systemUserInstance)
                springSecurityService.reauthenticate(systemUserInstance.username, systemUserInstance.password)
            } catch (Exception e) {
                e.printStackTrace()
                session.setAttribute(SpringSecurityUtils.SPRING_SECURITY_LAST_USERNAME_KEY, '')
                session.setAttribute('SPRING_SECURITY_LAST_PASSWORD', '')
                flash.errorTag = 2
                authFail()
                return
            }
            session.setAttribute(SpringSecurityUtils.SPRING_SECURITY_LAST_USERNAME_KEY, systemUserInstance.username)
        } else {
            try {
                validateAuthUser(systemUserInstance)
            } catch (Exception e) {
                session.setAttribute(SpringSecurityUtils.SPRING_SECURITY_LAST_USERNAME_KEY, '')
                session.setAttribute('SPRING_SECURITY_LAST_PASSWORD', '')
                flash.errorTag = 2
                authFail()
                return
            }
        }
        systemLogService.addLog(systemUserInstance.username, "${systemUserInstance.username}登录", NetUtil.getUserIP(request), "安全")
        redirect uri: SpringSecurityUtils.securityConfig.successHandler.defaultTargetUrl
    }

    def logout() {
        SecurityContextHolder.clearContext()
        redirect action: 'form'
    }
}
