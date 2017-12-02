package com.ybg.dsh.sys

import com.octo.captcha.service.CaptchaService
import grails.converters.JSON
import org.grails.web.util.WebUtils

import java.awt.image.BufferedImage

class JcaptchaController {
	JcaptchaService jcaptchaService

	def url() {
		def map = [:]
		def timeStamp = "" + Calendar.getInstance().getTimeInMillis()
		timeStamp = timeStamp.substring(0, 10);
		ConfigObject jcaptcha = grailsApplication.config.jcaptcha
		def jcaptchaName = jcaptcha.jcaptchaName as String
		map.url = createLink(controller: 'jcaptcha', action: 'jpeg', id: jcaptchaName) + '?id=' + timeStamp
		map.success = true
		render map as JSON
	}
	
	def jpeg(String id) {
		if (id == null)
			throw new IllegalStateException("JcaptchaController action called with no id (captcha name)")
		CaptchaService captcha = jcaptchaService.getCaptchaService(id)
		Object challenge = captcha.getChallengeForID(session.id, request.locale)
		if (challenge instanceof BufferedImage) {
			WebUtils.retrieveGrailsWebRequest().setRenderView(false)
			response.contentType = "image/jpeg"
			byte[] data = jcaptchaService.challengeAsJpeg(challenge)
			response.setHeader("Cache-Control", "no-cache, no-store,must-revalidate,max-age=0")
			response.setContentLength(data.length)
			response.setDateHeader("Expires", 0)
			response.outputStream << data
			return null
		} else {
			throw new IllegalArgumentException("Cannot render challenge ofcaptcha '${id}' as JPEG as it is not an image")
		}
	}
}