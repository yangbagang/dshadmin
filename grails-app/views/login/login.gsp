<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>报批报建管理系统</title>
    <meta name="description" content="报批报建管理系统">
    <meta name="author" content="杨拔纲">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The styles -->
    <asset:stylesheet id="bs-css" src="bootstrap-cerulean.min.css" />

    <asset:stylesheet src="charisma-app.css" />
    <link href='${resource(dir: "bower_components/fullcalendar/dist", file: "fullcalendar.css")}' rel='stylesheet'>
    <link href='${resource(dir: "bower_components/fullcalendar/dist", file: "fullcalendar.print.css")}' rel='stylesheet' media='print'>
    <link href='${resource(dir: "bower_components/chosen", file: "chosen.min.css")}' rel='stylesheet'>
    <link href='${resource(dir: "bower_components/colorbox/example3", file: "colorbox.css")}' rel='stylesheet'>
    <link href='${resource(dir: "bower_components/responsive-tables", file: "responsive-tables.css")}' rel='stylesheet'>
    <asset:stylesheet src="jquery.noty.css" />
    <asset:stylesheet src="noty_theme_default.css" />
    <asset:stylesheet src="elfinder.min.css" />
    <asset:stylesheet src="elfinder.theme.css" />
    <asset:stylesheet src="jquery.iphone.toggle.css" />
    <asset:stylesheet src="uploadify.css" />
    <asset:stylesheet src="animate.min.css" />

    <!-- jQuery -->
    <script src="${resource(dir: "bower_components/jquery", file: "jquery.min.js")}"></script>
    <!-- The HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <asset:javascript src="html5.js" />
    <![endif]-->

    <!-- The fav icon -->
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}">
    <style>
        .main-dev {
            position: absolute;
            width: 100%;
            height: 100%;
        }
        .carousel-inner .item img {
            width: 100%;
            height: 100vh;
        }
        .login-header h2 {
            color: #fefefe;
        }
    </style>
</head>
<body style="overflow: hidden;">
<div id="myCarousel" class="carousel slide" style="position: absolute;left: 0;right: 0;top: 0;bottom: 0;width: 100%;height: 100%;">
    <!-- 轮播（Carousel）项目 -->
    <div class="carousel-inner">
        <div class="item active">
            <asset:image src="login/login_1.jpg"/>
        </div>
        <div class="item">
            <asset:image src="login/login_2.jpg" />
        </div>
    </div>
</div>
<div class="ch-container">
    <div class="row">

        <div class="row">
            <div class="col-md-12 center login-header">
                <h2>报批报建管理系统</h2>
            </div>
            <!--/span-->
        </div><!--/row-->

        <div class="row">
            <div class="well col-md-5 center login-box" style="opacity:0.9;">
                <g:if test="${flash.message}">
                <div class="alert alert-info">
                    ${flash.message}
                </div>
                </g:if>
                <g:form controller="login" action="auth" method="POST">
                    <fieldset>
                        <div class="input-group input-group-lg">
                            <span class="input-group-addon" style="color: #5a5b82;"><i class="glyphicon glyphicon-user"></i></span>
                            <input type="text" name="username" class="form-control" placeholder="用户名">
                        </div>
                        <div class="clearfix"></div><br>

                        <div class="input-group input-group-lg">
                            <span class="input-group-addon" style="color: #5a5b82;"><i class="glyphicon glyphicon-lock"></i></span>
                            <input type="password" name="password" class="form-control" placeholder="密码">
                        </div>
                        <div class="clearfix"></div><br>
                        <g:set var="jcaptcha" value="${grailsApplication.config.jcaptcha}" />
                        <g:if test="${jcaptcha.enabled &&
                            session.jcaptchaForLogin == null ? true : session.jcaptchaForLogin}">
                            <div class="input-group input-group-lg">
                                <span class="input-group-addon" style="color: #5a5b82;"><i class="glyphicon glyphicon-lock"></i></span>
                                <input type="text" name="jcaptchaChallenge" class="form-control" placeholder="验证码">
                            </div>
                            <div class="clearfix"></div><br>
                            <div class="input-group input-group-lg">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <ybg:jcaptcha name="${jcaptcha.jcaptchaName}"/>
                            </div>
                            <div class="clearfix"></div><br>
                        </g:if>
                        <p class="center col-md-5">
                            <button type="submit" class="btn btn-primary">登录</button>
                        </p>
                    </fieldset>
                </g:form>
            </div>
            <!--/span-->
        </div><!--/row-->
    </div><!--/fluid-row-->

</div><!--/.fluid-container-->

<!-- external javascript -->
<script src="${resource(dir: "bower_components/bootstrap/dist/js", file: "bootstrap.min.js")}"></script>
<!-- library for cookie management -->
<asset:javascript src="jquery.cookie.js" />
<!-- calender plugin -->
<script src='${resource(dir: "bower_components/moment/min", file: "moment.min.js")}'></script>
<script src='${resource(dir: "bower_components/fullcalendar/dist", file: "fullcalendar.min.js")}'></script>
<!-- data table plugin -->
<asset:javascript src="jquery.dataTables.min.js" />
<!-- select or dropdown enhancer -->
<script src="${resource(dir: "bower_components/chosen", file: "chosen.jquery.min.js")}"></script>
<!-- plugin for gallery image view -->
<script src="${resource(dir: "bower_components/colorbox", file: "jquery.colorbox-min.js")}"></script>
<!-- notification plugin -->
<asset:javascript src="jquery.noty.js" />
<!-- library for making tables responsive -->
<script src="${resource(dir: "bower_components/responsive-tables", file: "responsive-tables.js")}"></script>
<!-- star rating plugin -->
<asset:javascript src="jquery.raty.min.js" />
<!-- for iOS style toggle switch -->
<asset:javascript src="jquery.iphone.toggle.js" />
<!-- autogrowing textarea plugin -->
<asset:javascript src="jquery.autogrow-textarea.js" />
<!-- multiple file upload plugin -->
<asset:javascript src="jquery.uploadify-3.1.min.js" />
<!-- history.js for cross-browser state change on ajax -->
<asset:javascript src="jquery.history.js" />
<!-- application script for Charisma demo -->
<asset:javascript src="charisma.js" />
<script>
    $(function() {
        var $img = $("#jcaptchaImg");
        $img.on('click', function () {
            $.ajax({
                url: '${createLink(controller: 'jcaptcha', action: 'url')}',
                type: 'POST',
                success: function (result) {
                    if (result.success) {
                        $img.prop('src', result.url)
                    }
                }
            });
        })
    });

    var tag = "${flash.errorTag}";
    if(tag==1){
        if($("input[name='jcaptchaChallenge']").length>0){
            $("input[name='jcaptchaChallenge']").eq(0).focus();
        }
    }else if(tag==2){
        if($("input[name='username']").length>0){
            $("input[name='username']").eq(0).val("");
            $("input[name='password']").eq(0).val("");
            $("input[name='username']").eq(0).focus();
        }
    }

    $('#myCarousel').carousel({
        interval: 2000
    })
</script>
</body>
</html>