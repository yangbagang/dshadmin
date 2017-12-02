package com.ybg.dsh.sys

import com.octo.captcha.component.image.backgroundgenerator.GradientBackgroundGenerator
import com.octo.captcha.component.image.color.SingleColorGenerator
import com.octo.captcha.component.image.fontgenerator.RandomFontGenerator
import com.octo.captcha.component.image.textpaster.DecoratedRandomTextPaster
import com.octo.captcha.component.image.textpaster.textdecorator.BaffleTextDecorator
import com.octo.captcha.component.image.textpaster.textdecorator.TextDecorator
import com.octo.captcha.component.image.wordtoimage.ComposedWordToImage
import com.octo.captcha.component.word.wordgenerator.RandomWordGenerator
import com.octo.captcha.engine.GenericCaptchaEngine
import com.octo.captcha.image.gimpy.GimpyFactory
import com.octo.captcha.service.multitype.GenericManageableCaptchaService

import java.awt.*

class JcaptchaConfig {

    static GenericManageableCaptchaService genericManageableCaptchaService = new GenericManageableCaptchaService(
            new GenericCaptchaEngine(
                    new GimpyFactory(
                            new RandomWordGenerator(
                                    "abcdefghijklmnopqrstuvwxyz1234567890"
                            ),
                            new ComposedWordToImage(
                                    new RandomFontGenerator(
                                            20, // min font size
                                            20, // max font size
                                            [new Font("Arial", Font.BOLD, 5)] as Font[]
                                    ),
                                    new GradientBackgroundGenerator(
                                            93, // width
                                            35, // height
                                            Color.WHITE,
                                            Color.WHITE
                                    ),
                                    new DecoratedRandomTextPaster(
                                            4, // minimal length of text
                                            4, // maximal length of text
                                            new SingleColorGenerator(Color.BLACK),
                                            [new BaffleTextDecorator(0, new SingleColorGenerator(
                                                    Color.WHITE))] as TextDecorator[]
                                    )
                            )
                    )
            ),
            180, // minGuarantedStorageDelayInSeconds
            100000, // maxCaptchaStoreSize
            75000 //captchaStoreLoadBeforeGarbageCollection
    )

    public static GenericManageableCaptchaService getGenericManageableCaptchaService() {
        return genericManageableCaptchaService
    }
}
