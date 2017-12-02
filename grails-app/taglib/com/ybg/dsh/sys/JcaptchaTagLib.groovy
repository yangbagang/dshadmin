package com.ybg.dsh.sys

class JcaptchaTagLib {

    static namespace = 'ybg'

    def jcaptcha = {
        def timeStamp = "" + Calendar.getInstance().getTimeInMillis()
        timeStamp = timeStamp.substring(0, 10);
        def link = g.createLink(controller: "jcaptcha", action: "jpeg", id: it.name)
        def attributes = []
        it.each { key, value -> if (key != "name" && key != "src") attributes << "${key}=\"${value}\"" }
        out << "<img id='jcaptchaImg' src=\"${link}?id=${timeStamp}\" ${attributes.join(' ')} />"
    }

}
