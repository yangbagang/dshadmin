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
    <link href='${resource(dir: "bower_components/bootstrap-tour/build/css", file: "bootstrap-tour.min.css")}' rel='stylesheet'>
    <asset:stylesheet src="jquery.noty.css" />
    <asset:stylesheet src="noty_theme_default.css" />
    <asset:stylesheet src="elfinder.min.css" />
    <asset:stylesheet src="elfinder.theme.css" />
    <asset:stylesheet src="jquery.iphone.toggle.css" />
    <asset:stylesheet src="uploadify.css" />
    <asset:stylesheet src="animate.min.css" />
    <asset:stylesheet src="jquery.dataTables.min.css" />

    <!-- jQuery -->
    <script src="${resource(dir: "bower_components/jquery", file: "jquery.min.js")}"></script>
    <!-- The HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <asset:javascript src="html5.js" />
    <![endif]-->

    <!-- The fav icon -->
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}">
</head>
<body>
<!-- topbar starts -->
<div class="navbar navbar-default" role="navigation">

    <div class="navbar-inner">
        <button type="button" class="navbar-toggle pull-left animated flip">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="${createLink(uri: '/')}"> <asset:image alt="Charisma Logo" src="logo20.png" class="hidden-xs"/>
            <span>报批报建管理系统</span></a>

        <!-- user dropdown starts -->
        <div class="btn-group pull-right">
            <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                <i class="glyphicon glyphicon-user"></i><span class="hidden-sm hidden-xs"><sec:loggedInUserInfo field='realName'/></span>
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu">
                <li><a href="#">设置</a></li>
                <li class="divider"></li>
                <li><a href="${createLink(uri: '/login/logout')}">退出</a></li>
            </ul>
        </div>
        <!-- user dropdown ends -->

        <!-- theme selector starts -->
        <div class="btn-group pull-right theme-container animated tada">
            <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                <i class="glyphicon glyphicon-tint"></i><span
                    class="hidden-sm hidden-xs">选择主题</span>
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu" id="themes">
                <li><a data-value="classic" href="#"><i class="whitespace"></i> Classic</a></li>
                <li><a data-value="cerulean" href="#"><i class="whitespace"></i> Cerulean</a></li>
                <li><a data-value="cyborg" href="#"><i class="whitespace"></i> Cyborg</a></li>
                <li><a data-value="simplex" href="#"><i class="whitespace"></i> Simplex</a></li>
                <li><a data-value="darkly" href="#"><i class="whitespace"></i> Darkly</a></li>
                <li><a data-value="lumen" href="#"><i class="whitespace"></i> Lumen</a></li>
                <li><a data-value="slate" href="#"><i class="whitespace"></i> Slate</a></li>
                <li><a data-value="spacelab" href="#"><i class="whitespace"></i> Spacelab</a></li>
                <li><a data-value="united" href="#"><i class="whitespace"></i> United</a></li>
            </ul>
        </div>
        <!-- theme selector ends -->
    </div>
</div>
<!-- topbar ends -->
<div class="ch-container">
    <div class="row">

        <!-- left menu starts -->
        <div class="col-sm-2 col-lg-2">
            <div class="sidebar-nav">
                <div class="nav-canvas">
                    <div class="nav-sm nav nav-stacked">

                    </div>
                    <ul class="nav nav-pills nav-stacked main-menu">
                        <li class="nav-header">菜单</li>
                        <li><a class="ajax-link" href="${createLink(uri: '/main')}"><i class="glyphicon glyphicon-home"></i><span> 首页</span></a>
                        </li>
                        <sec:access expression="hasAnyRole('ROLE_SYSTEM_ADMIN','ROLE_SUPER_ADMIN')">
                        <li class="accordion">
                            <a href="#"><i class="glyphicon glyphicon-user"></i><span> 系统管理</span></a>
                            <ul class="nav nav-pills nav-stacked">
                                <li><a class="ajax-link" href="${createLink(uri: '/systemUser')}">管理员设置</a></li>
                                <li><a class="ajax-link" href="${createLink(uri: '/systemRole')}">角色设置</a></li>
                                <li><a class="ajax-link" href="${createLink(uri: '/systemUserRole')}">权限设置</a></li>
                                <li><a class="ajax-link" href="${createLink(uri: '/systemLog')}">系统日志</a></li>
                            </ul>
                        </li>
                        </sec:access>
                        <li class="accordion">
                            <a href="#"><i class="glyphicon glyphicon-user"></i><span> 法律法规</span></a>
                            <ul class="nav nav-pills nav-stacked">
                                <li><a class="ajax-link" href="${createLink(uri: '/fileInfo')}">法律法规</a></li>
                            </ul>
                        </li>
                        <li class="accordion">
                            <a href="#"><i class="glyphicon glyphicon-user"></i><span> 流程管理</span></a>
                            <ul class="nav nav-pills nav-stacked">
                                <li><a class="ajax-link" href="${createLink(uri: '/workFlow')}">流程定义</a></li>
                                <li><a class="ajax-link" href="${createLink(uri: '/flowDefinition')}">流程设置</a></li>
                                <li><a class="ajax-link" href="${createLink(uri: '/workTask')}">节点配置</a></li>
                            </ul>
                        </li>
                        <li class="accordion">
                            <a href="#"><i class="glyphicon glyphicon-user"></i><span> 项目管理</span></a>
                            <ul class="nav nav-pills nav-stacked">
                                <li><a class="ajax-link" href="${createLink(uri: '/project')}">项目管理</a></li>
                                <li><a class="ajax-link" href="${createLink(uri: '/project/index4')}">未启动项目</a></li>
                                <li><a class="ajax-link" href="${createLink(uri: '/project/index2')}">进行中项目</a></li>
                                <li><a class="ajax-link" href="${createLink(uri: '/project/index3')}">己完结项目</a></li>
                                <li><a class="ajax-link" href="${createLink(uri: '/projectTask/index1')}">待办任务</a></li>
                                <li><a class="ajax-link" href="${createLink(uri: '/projectTask/index2')}">己办任务</a></li>
                            </ul>
                        </li>
                        <li class="accordion">
                            <a href="#"><i class="glyphicon glyphicon-user"></i><span> 项目资料</span></a>
                            <ul class="nav nav-pills nav-stacked">
                                <li><a class="ajax-link" href="${createLink(uri: '/project/files')}">项目资料</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <!--/span-->
        <!-- left menu ends -->

        <noscript>
            <div class="alert alert-block col-md-12">
                <h4 class="alert-heading">Warning!</h4>

                <p>You need to have <a href="http://en.wikipedia.org/wiki/JavaScript" target="_blank">JavaScript</a>
                    enabled to use this site.</p>
            </div>
        </noscript>

        <div id="content" class="col-lg-10 col-sm-10">
            <!-- content starts -->
            <div>
                <ul class="breadcrumb">
                    <li>
                        <a href="#">Home</a>
                    </li>
                    <li>
                        <a href="#">Dashboard</a>
                    </li>
                </ul>
            </div>
            <div class="box-inner">
                <div class="box-header well">
                    <h2><i class="glyphicon glyphicon-ok-sign"></i> Welcome</h2>

                    <div class="box-icon">
                        <a href="#" class="btn btn-setting btn-round btn-default"><i
                                class="glyphicon glyphicon-cog"></i></a>
                        <a href="#" class="btn btn-minimize btn-round btn-default"><i
                                class="glyphicon glyphicon-chevron-up"></i></a>
                        <a href="#" class="btn btn-close btn-round btn-default"><i
                                class="glyphicon glyphicon-remove"></i></a>
                    </div>
                </div>
                <div class="box-content alerts">
                    <div class="alert alert-info">
                        <button type="button" class="close" data-dismiss="alert">&times;</button>
                        欢迎 <strong><sec:loggedInUserInfo field='realName'/></strong> 再次回来。再次回来。当前版本定位于体验，相关数据随时会清空。
                    </div>
                </div>
            </div>
            <!-- content ends -->
        </div><!--/#content.col-md-0-->
    </div><!--/fluid-row-->

    <hr>

    <footer class="row">
        <p class="col-md-9 col-sm-9 col-xs-12 copyright">&copy; 报批报建管理系统 2018 </p>

        <p class="col-md-3 col-sm-3 col-xs-12 powered-by">技术支持: 企业信息化小组</p>
    </footer>

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
<!-- tour plugin -->
<script src="${resource(dir: "bower_components/bootstrap-tour/build/js", file: "bootstrap-tour.min.js")}"></script>
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
</body>
</html>
