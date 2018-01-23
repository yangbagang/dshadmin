<!DOCTYPE html>
<html xmlns:v="urn:schemas-microsoft-com:vml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>报批报建管理系统 - 流程设计 - ${flow.name}</title>
    <!--[if lt IE 9]>
<?import namespace="v" implementation="#default#VML" ?>
<![endif]-->
    <link rel="stylesheet" type="text/css" href="${resource(dir: "bower_components/gooflow/css", file: "default.css")}"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: "bower_components/gooflow/fonts", file: "iconflow.css")}"/>
    <link rel="stylesheet" type="text/css" href="${resource(dir: "bower_components/gooflow/css", file: "GooFlow.css")}"/>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/plugin", file: "jquery.min.js")}"></script>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/js", file: "GooFunc.js")}"></script>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/plugin", file: "json2.js")}"></script>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/plugin", file: "printThis.js")}"></script>

    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/js", file: "GooFlow.js")}"></script>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/js", file: "GooFlow.color.js")}"></script>
    <script type="text/javascript" src="${resource(dir: "bower_components/gooflow/js", file: "GooFlow.export.js")}"></script>
    <script type="text/javascript">
        var flowId = ${flow.id};
        var property={
            toolBtns:["start round mix","end round","task","node","chat","state","plug","join","fork","complex mix"],
            haveHead:true,
            headLabel:true,
            headBtns:["save","undo","redo","reload"],//如果haveHead=true，则定义HEAD区的按钮
            haveTool:true,
            haveDashed:true,
            haveGroup:true,
            useOperStack:true
        };
        //取代setNodeRemarks方法，采用更灵活的注释配置
        GooFlow.prototype.remarks.toolBtns={
            cursor:"选择指针",
            direct:"结点连线",
            dashed:"关联虚线",
            start:"入口结点",
            "end":"结束结点",
            "task":"任务结点",
            node:"自动结点",
            chat:"决策结点",
            state:"状态结点",
            plug:"附加插件",
            fork:"分支结点",
            "join":"联合结点",
            "complex":"复合结点",
            group:"组织划分框编辑开关"
        };
        GooFlow.prototype.remarks.headBtns={
            save:"保存结果",
            undo:"撤销",
            redo:"重做",
            reload:"刷新流程"
        };
        GooFlow.prototype.remarks.extendRight="工作区向右扩展";
        GooFlow.prototype.remarks.extendBottom="工作区向下扩展";
        var demo;
        $(document).ready(function(){
            demo=$.createGooFlow($("#flowJSON"),property);
            loadFlowDefinition();
            demo.onItemRightClick=function(id,type){
                console.log("onItemRightClick: "+id+","+type);
                return true;//返回false可以阻止浏览器默认的右键菜单事件
            };
            demo.onItemDbClick=function(id,type){
                console.log("onItemDbClick: "+id+","+type);
                return true;//返回false可以阻止原组件自带的双击直接编辑事件
            };
            demo.onFreshClick=function () {
                loadFlowDefinition();
            };
            demo.onBtnSaveClick=function () {
                $("#msg").html("正在保存...");
                var context = JSON.stringify(demo.exportData());
                $.ajax({
                    type: "POST",
                    dataType: "json",
                    url: "update",
                    data: "flowId="+ flowId + "&context=" + context,
                    success: function (result) {
                        flowId = result.id;
                        $("#msg").html("设置保存成功");
                    },
                    error: function (data) {
                        $("#msg").html(data.responseText);
                    }
                });
            };
        });
        window.onresize=function(){
            flowJSON.reinitSize(window.innerWidth-15,window.innerHeight-30);
        };
        function loadFlowDefinition() {
            demo.loadDataAjax({
                type: "GET",
                url: "viewContext?flowId=" + flowId,
                success: function (result) {
                    demo.loadData(result);
                    demo.setTitle('流程设计 - ${flow.name}');
                },
                error: function (data) {
                    $("#msg").html(data.responseText);
                }
            });
        }
    </script>
</head>
<body>
<div id="flowJSON" style="width:100%;height:540px;"></div>
<div id="msg"></div>
</body>
</html>
