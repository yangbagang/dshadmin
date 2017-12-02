package com.ybg.dsh.utils

import org.apache.commons.lang.StringUtils

import javax.servlet.http.HttpServletRequest

/**
 * Created by yangbagang on 16/6/27.
 */
class NetUtil {

    static String getUserIP(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for")
        if (StringUtils.isEmpty(ip) || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP")
        }
        if (StringUtils.isEmpty(ip) || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP")
        }
        if (StringUtils.isEmpty(ip) || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr()
            if ("127.0.0.1" == ip || "0:0:0:0:0:0:0:1" == ip) {
                InetAddress inet = null;    // 根据网卡取本机配置的IP
                try {
                    inet = InetAddress.getLocalHost()
                    ip = inet.getHostAddress()
                } catch (UnknownHostException e) {
                    e.printStackTrace();
                }
            }
        }
        // 对于通过多个代理的情况，第一个IP为客户端真实IP,多个IP按照','分割
        if (ip != null && ip.length() > 15) { // "***.***.***.***".length() = 15
            if (ip.indexOf(",") > 0) {
                ip = ip.substring(0, ip.indexOf(","))
            }
        }
        return ip;
    }

}
