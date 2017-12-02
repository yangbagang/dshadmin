package com.ybg.dsh.sys

import com.octo.captcha.service.CaptchaService

import javax.imageio.IIOImage
import javax.imageio.ImageIO
import javax.imageio.ImageWriteParam
import javax.imageio.ImageWriter
import javax.imageio.metadata.IIOMetadata
import javax.imageio.plugins.jpeg.JPEGImageWriteParam
import javax.imageio.stream.ImageOutputStream
import java.awt.image.BufferedImage

class JcaptchaService {

    CaptchaService getCaptchaService(String captchaName) {
        if (captchaName == null)
            throw new IllegalArgumentException("'captchaName' cannot be null")
        def c = JcaptchaConfig.getGenericManageableCaptchaService()
        if (c == null)
            throw new IllegalStateException("There is no jcaptcha defined with name '${captchaName}'")
        return c
    }

    boolean validateResponse(captchaName, id, response) {
        def c = getCaptchaService(captchaName)
        c.validateResponseForID(id, response)
    }

    byte[] challengeAsJpeg(BufferedImage challenge) {
        ByteArrayOutputStream jpegOutputStream = new ByteArrayOutputStream()
        try {
            ImageOutputStream imageOutputStream = ImageIO.createImageOutputStream(jpegOutputStream)
            try {
                ImageWriter jpegEncoder = (ImageWriter) ImageIO.getImageWritersByFormatName("JPEG").next()
                JPEGImageWriteParam param = new JPEGImageWriteParam(null)
                param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT)
                param.setCompressionQuality(new Float(1.0).floatValue())
                jpegEncoder.setOutput(imageOutputStream)
                jpegEncoder.write((IIOMetadata) null, new IIOImage(challenge, null, null), param)
                return jpegOutputStream.toByteArray()
            } finally {
                imageOutputStream.close()
            }
        } finally {
            jpegOutputStream.close()
        }
    }
}
