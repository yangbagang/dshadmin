<!DOCTYPE html>
<html xmlns:v="urn:schemas-microsoft-com:vml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>项目进展 - ${project?.name}</title>
    <!--[if lt IE 9]>
<?import namespace="v" implementation="#default#VML" ?>
<![endif]-->
    <link rel="stylesheet" type="text/css" href="${resource(dir: "bower_components/gooflow/css", file: "default.css")}"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: "bower_components/gooflow/fonts", file: "iconflow.css")}"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: "bower_components/gooflow/css", file: "GooFlow.css")}"/>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/js", file: "GooFunc.js")}"></script>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/plugin", file: "json2.js")}"></script>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/plugin", file: "printThis.js")}"></script>

    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/js", file: "GooFlow.js")}"></script>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/js", file: "GooFlow.color.js")}"></script>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/js", file: "GooFlow.export.js")}"></script>
    <script type="text/javascript">
        var flowId = ${project?.flowId};
        var flowUrl = "${createLink(controller: 'flowDefinition', action: 'viewContext')}";
        var property={
            toolBtns:[],
            haveHead:true,
            headLabel:true,
            headBtns:[],//如果haveHead=true，则定义HEAD区的按钮
            haveTool:false,
            haveDashed:true,
            haveGroup:true,
            useOperStack:true
        };
        GooFlow.prototype.remarks.extendRight="工作区向右扩展";
        GooFlow.prototype.remarks.extendBottom="工作区向下扩展";
        var demo_view;
        $(document).ready(function(){
            demo_view=$.createGooFlow($("#flowJSON_view"),property);
            loadFlowView();
            demo_view.onItemDbClick=function(id,type){
                editTask(id, ${project.id});
                return false;//返回false可以阻止原组件自带的双击直接编辑事件
            };
        });
        function loadFlowView() {
            demo_view.loadDataAjax({
                type: "GET",
                url: flowUrl + "?flowId=" + flowId,
                success: function (result) {
                    demo_view.loadData(result);
                    <g:each in="${taskIds}" var="taskId">
                    demo_view.markItem('${taskId}', 'node', true);
                    </g:each>
                    demo_view.setTitle('${project?.name}进展');
                    demo_view.editable = false;
                },
                error: function (data) {
                    $("#msg_view").html(data.responseText);
                }
            });
        }
    </script>
</head>
<body>
<div id="flowJSON_view" style="width:100%;height:600px;"></div>
<div id="msg_view"></div>
</body>
</html>
