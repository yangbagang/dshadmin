package com.ybg.dsh.sys

import com.google.common.cache.CacheBuilder
import com.google.common.cache.CacheLoader
import com.google.common.cache.LoadingCache
import org.springframework.web.context.request.RequestContextHolder

import javax.annotation.PostConstruct
import javax.servlet.http.HttpSession
import java.util.concurrent.TimeUnit

class JcaptchaLimitService {

    def grailsApplication

    private LoadingCache<String, Integer> attempts

    private Integer allowedNumberOfAttempts


    @PostConstruct
    void init() {

        ConfigObject config = grailsApplication.config.jcaptcha

        allowedNumberOfAttempts = config.containsKey("allowedNumberOfAttempts") ? config.allowedNumberOfAttempts : 3

        Integer time = config.containsKey("time") ? config.time : 5

        attempts = CacheBuilder.newBuilder()
                .expireAfterWrite(time, TimeUnit.MINUTES)
                .build({ 0 } as CacheLoader)
    }

    boolean failLogin(String jsessionId) {
        boolean flag = false
        int numberOfAttempts = attempts.get(jsessionId)
        numberOfAttempts++

        if (numberOfAttempts >= allowedNumberOfAttempts) {
            deactivateJcaptcha()
            attempts.invalidate(jsessionId)
            flag = true
        } else {
            attempts.put(jsessionId, numberOfAttempts)
        }
        return flag
    }

    void loginSuccess(String jsessionId) {
        attempts.invalidate(jsessionId)
    }

    def deactivateJcaptcha() {
        ConfigObject config = grailsApplication.config.jcaptcha
        Integer time = config.containsKey("time") ? config.time : 5
        HttpSession session = RequestContextHolder.currentRequestAttributes().session
        session.jcaptchaForLogin = false
        session.setMaxInactiveInterval(time)
    }

}
