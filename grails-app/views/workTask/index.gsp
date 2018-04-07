<div>
    <ul class="breadcrumb">
        <li>
            <a href="#">流程管理</a>
        </li>
        <li>
            <a href="#">节点配置</a>
        </li>
    </ul>
</div>
<div class="box-inner">
    <div class="box-header well" data-original-title="">
        <h2><i class="glyphicon glyphicon-user"></i> 节点配置</h2>
        <div class="box-icon">
            <a href="#" class="btn btn-minimize btn-round btn-default"><i
                    class="glyphicon glyphicon-chevron-up"></i></a>
            <a href="#" class="btn btn-close btn-round btn-default"><i
                    class="glyphicon glyphicon-remove"></i></a>
        </div>
    </div>
</div>
<div class="box-content">
    <form class="form-inline" role="form" action="#">
        <div class="form-group">
            <label class="control-label" for="flowId">流程:</label>
            <select id="flowId" name="flowId"></select>
        </div>
    </form><br />
    <div id="msgInfo" class="box-content alerts"></div>
    <table class="table table-striped table-bordered search_table" id="dataTable"></table>
</div>

<div class="box-inner">
    <div class="box-header well" data-original-title="">
        <h2><i class="glyphicon glyphicon-user"></i> <span id="op_title2">绑定操作人 - 未选定任务</span></h2>
        <div class="box-icon">
            <a href="#" class="btn btn-minimize btn-round btn-default"><i
                    class="glyphicon glyphicon-chevron-up"></i></a>
            <a href="#" class="btn btn-close btn-round btn-default"><i
                    class="glyphicon glyphicon-remove"></i></a>
        </div>
    </div>
</div>
<div class="box-content">
    <form class="form-inline" role="form" action="#">
        <div class="form-group">
            <label class="control-label" for="userId">操作人:</label>
            <select id="userId" name="userId"></select>
            <input type="button" value="绑定" onclick="addAssign();">&nbsp;&nbsp;
            <input type="button" value="全部绑定" onclick="assignAll();">
        </div>
    </form><br />
    <div id="assignInfo" class="box-content alerts"></div>
    <table class="table table-striped table-bordered search_table" id="dataTable2"></table>
</div>

<div class="box-inner">
    <div class="box-header well" data-original-title="">
        <h2><i class="glyphicon glyphicon-user"></i> <span id="op_title3">表单配置 - 未选定任务</span></h2>
        <div class="box-icon">
            <a href="javascript:addFormInfo();" class="btn btn-plus btn-round btn-default"><i
                    class="glyphicon glyphicon-plus"></i></a>
            <a href="#" class="btn btn-minimize btn-round btn-default"><i
                    class="glyphicon glyphicon-chevron-up"></i></a>
            <a href="#" class="btn btn-close btn-round btn-default"><i
                    class="glyphicon glyphicon-remove"></i></a>
        </div>
    </div>
</div>
<div class="box-content">
    <div id="msgFormInfo" class="box-content alerts"></div>
    <table class="table table-striped table-bordered search_table" id="dataTable3"></table>
</div>

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">

    <div class="modal-dialog">
        <div class="modal-content" id="modal-content">

        </div>
    </div>
</div>

<script>
    var gridTable;
    var gridTable2;
    var gridTable3;
    var taskId = 0;
    $(document).ready(function(){
        var table=$('#dataTable').DataTable({
            "bLengthChange": true,
            "bFilter": false,
            "lengthMenu": [10, 20, 50, 100],
            "paginate": false,
            "processing": true,
            "pagingType": "full_numbers",
            "serverSide": true,
            "bAutoWidth": true,
            "ajax": {
                "url":"workTask/list",
                "dataSrc": "data",
                "data": function ( d ) {
                    //添加额外的参数传给服务器
                    d.flowId = $("#flowId").val();
                }
            },
            "order": [[2, 'asc']], // 默认排序(第三列降序, asc升序)
            "columns": [
                { "title": "任务名称", "data" : "name", "orderable": true, "searchable": false },
                { "title": "流程名称", "data" : "flowName", "orderable": false, "searchable": false },
                { "title": "更新时间", "data" : "createTime", "orderable": true, "searchable": false },
                { "title": "类型", "data" : "taskType", "orderable": true, "searchable": false },
                { "title": "操作", "data" : function (data) {
                    return  '<a class="btn btn-info" href="javascript:loadInfo('+data.id+', \''+data.name+'\');" title="编辑">' +
                            '<i class="glyphicon glyphicon-edit icon-white"></i></a>';
                }, "orderable": false, "searchable": false }
            ],
            "language": {
                "zeroRecords": "没有数据",
                "lengthMenu" : "_MENU_",
                "info": "显示第 _START_ 至 _END_ 条记录，共 _TOTAL_ 条",
                "loadingRecords": "加载中...",
                "processing": "加载中...",
                "infoFiltered": "",
                "infoEmpty": "暂无记录",
                "paginate": {
                    "first": "首页",
                    "last": "末页",
                    "next": "下一页",
                    "previous": "上一页"
                }
            }
        });
        var table2=$('#dataTable2').DataTable({
            "bLengthChange": true,
            "bFilter": false,
            "lengthMenu": [10, 20, 50, 100],
            "paginate": false,
            "processing": true,
            "pagingType": "full_numbers",
            "serverSide": true,
            "bAutoWidth": true,
            "ajax": {
                "url":"taskAssign/list",
                "dataSrc": "data",
                "data": function ( d ) {
                    //添加额外的参数传给服务器
                    d.taskId = taskId;
                }
            },
            "order": [[2, 'asc']], // 默认排序(第三列降序, asc升序)
            "columns": [
                { "title": "任务名称", "data" : "taskName", "orderable": true, "searchable": false },
                { "title": "操作人名称", "data" : "userName", "orderable": false, "searchable": false },
                { "title": "更新时间", "data" : "createTime", "orderable": true, "searchable": false },
                { "title": "操作", "data" : function (data) {
                        return  '<a class="btn btn-danger" href="javascript:removeAssign('+data.id+');" title="删除">' +
                                '<i class="glyphicon glyphicon-trash icon-white"></i></a>';
                    }, "orderable": false, "searchable": false }
            ],
            "language": {
                "zeroRecords": "没有数据",
                "lengthMenu" : "_MENU_",
                "info": "显示第 _START_ 至 _END_ 条记录，共 _TOTAL_ 条",
                "loadingRecords": "加载中...",
                "processing": "加载中...",
                "infoFiltered": "",
                "infoEmpty": "暂无记录",
                "paginate": {
                    "first": "首页",
                    "last": "末页",
                    "next": "下一页",
                    "previous": "上一页"
                }
            }
        });
        var table3=$('#dataTable3').DataTable({
            "bLengthChange": true,
            "bFilter": false,
            "lengthMenu": [10, 20, 50, 100],
            "paginate": false,
            "processing": true,
            "pagingType": "full_numbers",
            "serverSide": true,
            "bAutoWidth": true,
            "ajax": {
                "url":"taskForm/list",
                "dataSrc": "data",
                "data": function ( d ) {
                    //添加额外的参数传给服务器
                    d.taskId = taskId;
                }
            },
            "order": [[0, 'asc']], // 默认排序(第三列降序, asc升序)
            "columns": [
                { "title": "英文名", "data" : "keyName", "orderable": true, "searchable": false },
                { "title": "中文名", "data" : "labelName", "orderable": false, "searchable": false },
                { "title": "类型", "data" : "type", "orderable": true, "searchable": false },
                { "title": "是否空白", "data" : "isBlank", "orderable": true, "searchable": false },
                { "title": "是否隐藏", "data" : "isHidden", "orderable": true, "searchable": false },
                { "title": "操作", "data" : function (data) {
                        return '<a class="btn btn-info" href="javascript:editFormInfo('+data.id+');" title="编辑">' +
                            '<i class="glyphicon glyphicon-edit icon-white"></i></a>&nbsp;&nbsp;' +
                            '<a class="btn btn-danger" href="javascript:removeFormInfo('+data.id+');" title="删除">' +
                            '<i class="glyphicon glyphicon-trash icon-white"></i></a>';
                    }, "orderable": false, "searchable": false }
            ],
            "language": {
                "zeroRecords": "没有数据",
                "lengthMenu" : "_MENU_",
                "info": "显示第 _START_ 至 _END_ 条记录，共 _TOTAL_ 条",
                "loadingRecords": "加载中...",
                "processing": "加载中...",
                "infoFiltered": "",
                "infoEmpty": "暂无记录",
                "paginate": {
                    "first": "首页",
                    "last": "末页",
                    "next": "下一页",
                    "previous": "上一页"
                }
            }
        });
        gridTable = table;
        gridTable2 = table2;
        gridTable3 = table3;
        //查询 重新加载
        $("#flowId").change(function(){
            table.ajax.reload(null, false);
        });
        loadDefinitionList();
        loadUserList();
    });

    function loadDefinitionList() {
        var url = '${createLink(controller: "flowDefinition", action: "flowList")}';
        $.ajax({
            type: "get",
            dataType: "json",
            url: url,
            data: "",
            success: function (result) {
                $("#flowId").empty();
                $.each(result, function (index, item) {
                    $("#flowId").append("<option value='"+item.flowId+"'>"+item.flowName+"</option>");
                });
                //默认查询
                gridTable.ajax.reload(null, false);
            }
        });
    }

    function loadUserList() {
        var url = '${createLink(controller: "taskAssign", action: "listUsers")}';
        $.ajax({
            type: "get",
            dataType: "json",
            url: url,
            data: "",
            success: function (result) {
                $("#userId").empty();
                $.each(result, function (index, item) {
                    $("#userId").append("<option value='"+item.userId+"'>"+item.userName+"</option>");
                });
            }
        });
        //默认查询
        gridTable.ajax.reload(null, false);
    }

    function loadInfo(id, name) {
        taskId = id;
        $("#op_title2").html("绑定操作人 - " + name);
        $("#op_title3").html("表单配置 - " + name);
        gridTable2.ajax.reload(null, false);
        gridTable3.ajax.reload(null, false);
    }

    function addAssign() {
        if (taskId == 0) {
            alert("请选定需要绑定的任务。");
            return;
        }
        var userId = $("#userId").val();
        var url = '${createLink(controller: "taskAssign", action: "save")}';
        $.ajax({
            type: "POST",
            url: url,
            data: "taskId="+taskId+"&userId="+userId,
            success: function (result) {
                var isSuccess = result.success;
                var errorMsg = result.msg;
                var content = "";
                if (eval(isSuccess)) {
                    content = "" +
                        '<div class="alert alert-success">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        '操作完成' +
                        '</div>';
                } else {
                    content = "" +
                        '<div class="alert alert-danger">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        JSON.stringify(errorMsg) +
                        '</div>';
                }
                $("#myModal").modal('hide');
                gridTable2.ajax.reload(null, false);
                $("#assignInfo").html(content).fadeIn(300).delay(2000).fadeOut(300);
            },
            error: function(data) {
                var errorContent = "" +
                    '<div class="alert alert-danger">' +
                    '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                    data.responseText +
                    '</div>';
                $("#assignInfo").html(errorContent);
                $("#assignInfo").html(errorContent).fadeIn(300).delay(2000).fadeOut(300);
            }
        });
    }

    function removeAssign(id) {
        var content = "" +
            '<div class="modal-header">' +
            '<button type="button" class="close" data-dismiss="modal">×</button>' +
            '<h3>提示</h3>' +
            '</div>' +
            '<div class="modal-body">' +
            '<p>删除后信息将无法恢复,是否继续?</p>' +
            '</div>' +
            '<div class="modal-footer">' +
            '<a href="#" class="btn btn-default" data-dismiss="modal">取消</a>' +
            '<a href="javascript:postAssignRemove('+id+');" class="btn btn-primary">删除</a>' +
            '</div>';
        $("#modal-content").html("");
        $("#modal-content").html(content);
        $('#myModal').modal('show');
    }

    function postAssignRemove(id) {
        var url = '${createLink(controller: "taskAssign", action: "delete")}/' + id;
        $.ajax({
            type: "DELETE",
            dataType: "json",
            url: url,
            success: function (result) {
                var isSuccess = result.success;
                var errorMsg = result.msg;
                var content = "";
                if (isSuccess) {
                    content = "" +
                        '<div class="alert alert-success">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        '删除完成' +
                        '</div>';
                } else {
                    content = "" +
                        '<div class="alert alert-danger">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        errorMsg +
                        '</div>';
                }
                $("#myModal").modal('hide');
                gridTable2.ajax.reload(null, false);
                $("#assignInfo").html(content);
                $("#assignInfo").html(content).fadeIn(300).delay(2000).fadeOut(300);
            },
            error: function (data) {
                var errorContent = "" +
                    '<div class="alert alert-danger">' +
                    '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                    data.responseText +
                    '</div>';
                $("#assignInfo").html(errorContent);
                $("#assignInfo").html(errorContent).fadeIn(300).delay(2000).fadeOut(300);
            }
        });
    }

    function addFormInfo() {
        if (taskId == 0) {
            alert("请选定需要配置的任务。");
            return;
        }
        var content = "" +
                '<div class="modal-header">' +
                '<button type="button" class="close" data-dismiss="modal">×</button>' +
                '<h3>新建表单项</h3>' +
                '</div>' +
                '<div class="modal-body">' +
                '<form id="infoForm" role="form">' +
                '<input type="hidden" id="workTask.id" name="workTask.id" value="' + taskId + '">' +
                '<div class="form-group">' +
                '<label for="keyName">英文名</label>' +
                '<input type="text" class="form-control" id="keyName" name="keyName" placeholder="keyName，区分大小写，不能有空格。">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="labelName">中文名</label>' +
                '<input type="text" class="form-control" id="labelName" name="labelName" placeholder="中文标识名，用作提示。">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="type">类型</label>' +
                '<select name="type" id="type"><option value="text">文本</option><option value="file">文件</option></select>' +
                '</div>' +
                '</form>' +
                '</div>' +
                '<div class="modal-footer">' +
                '<a href="#" class="btn btn-default" data-dismiss="modal">关闭</a>' +
                '<a href="javascript:postAjaxForm();" class="btn btn-primary">保存</a>' +
                '</div>';
        $("#modal-content").html("");
        $("#modal-content").html(content);
        $('#myModal').modal('show');
    }

    function editFormInfo(id) {
        var url = '${createLink(controller: "taskForm", action: "show")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "id=" + id,
            success: function (result) {
                var content = "" +
                        '<div class="modal-header">' +
                        '<button type="button" class="close" data-dismiss="modal">×</button>' +
                        '<h3>编辑表单项</h3>' +
                        '</div>' +
                        '<div class="modal-body">' +
                        '<form id="infoForm" role="form">' +
                        '<input type="hidden" id="id" name="id" value="' + result.id + '">' +
                        '<input type="hidden" id="workTask.id" name="workTask.id" value="' + result.workTask.id + '">' +
                        '<div class="form-group">' +
                        '<label for="keyName">英文名</label>' +
                        '<input type="text" class="form-control" id="keyName" name="keyName" value="'+result.keyName+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="labelName">中文名</label>' +
                        '<input type="text" class="form-control" id="labelName" name="labelName" value="'+result.labelName+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="type">类型</label>' +
                        '<select name="type" id="type"><option value="text">文本</option><option value="file">文件</option></select>' +
                        '</div>' +
                        '</form>' +
                        '</div>' +
                        '<div class="modal-footer">' +
                        '<a href="#" class="btn btn-default" data-dismiss="modal">关闭</a>' +
                        '<a href="javascript:postAjaxForm();" class="btn btn-primary">更新</a>' +
                        '</div>';
                $("#modal-content").html("");
                $("#modal-content").html(content);
                $('#myModal').modal('show');
                $("#type").val(result.type);
            },
            error: function (data) {
                showErrorInfo(data.responseText);
            }
        });
    }

    function removeFormInfo(id) {
        var content = "" +
                '<div class="modal-header">' +
                '<button type="button" class="close" data-dismiss="modal">×</button>' +
                '<h3>提示</h3>' +
                '</div>' +
                '<div class="modal-body">' +
                '<p>删除后信息将无法恢复,是否继续?</p>' +
                '</div>' +
                '<div class="modal-footer">' +
                '<a href="#" class="btn btn-default" data-dismiss="modal">取消</a>' +
                '<a href="javascript:postAjaxRemove('+id+');" class="btn btn-primary">删除</a>' +
                '</div>';
        $("#modal-content").html("");
        $("#modal-content").html(content);
        $('#myModal').modal('show');
    }

    function postAjaxRemove(id) {
        var url = '${createLink(controller: "taskForm", action: "delete")}/' + id;
        $.ajax({
            type: "DELETE",
            dataType: "json",
            url: url,
            success: function (result) {
                var isSuccess = result.success;
                var errorMsg = result.msg;
                var content = "";
                if (isSuccess) {
                    content = "" +
                            '<div class="alert alert-success">' +
                            '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                            '删除完成' +
                            '</div>';
                } else {
                    content = "" +
                            '<div class="alert alert-danger">' +
                            '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                            errorMsg +
                            '</div>';
                }
                $("#myModal").modal('hide');
                gridTable3.ajax.reload(null, false);
                $("#msgFormInfo").html(content);
                $("#msgFormInfo").html(content).fadeIn(300).delay(2000).fadeOut(300);
            },
            error: function (data) {
                var errorContent = "" +
                        '<div class="alert alert-danger">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        data.responseText +
                        '</div>';
                $("#msgFormInfo").html(errorContent);
                $("#msgFormInfo").html(errorContent).fadeIn(300).delay(2000).fadeOut(300);
            }
        });
    }

    function postAjaxForm() {
        var url = '${createLink(controller: "taskForm", action: "save")}';
        $.ajax({
            type: "POST",
            dataType: "json",
            url: url,
            data: $('#infoForm').serialize(),
            success: function (result) {
                var isSuccess = result.success;
                var errorMsg = result.msg;
                var content = "";
                if (eval(isSuccess)) {
                    content = "" +
                            '<div class="alert alert-success">' +
                            '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                            '操作完成' +
                            '</div>';
                } else {
                    content = "" +
                            '<div class="alert alert-danger">' +
                            '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                            JSON.stringify(errorMsg) +
                            '</div>';
                }
                $("#myModal").modal('hide');
                gridTable3.ajax.reload(null, false);
                $("#msgFormInfo").html(content).fadeIn(300).delay(2000).fadeOut(300);
            },
            error: function(data) {
                var errorContent = "" +
                        '<div class="alert alert-danger">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        data.responseText +
                        '</div>';
                $("#msgFormInfo").html(errorContent);
                $("#msgFormInfo").html(errorContent).fadeIn(300).delay(2000).fadeOut(300);
            }
        });
    }

    function assignAll() {
        var flowId = $("#flowId").val();
        var userId = $("#userId").val();
        var url = '${createLink(controller: "taskAssign", action: "assignAll")}';
        $.ajax({
            type: "POST",
            url: url,
            data: "flowId="+flowId+"&userId="+userId,
            success: function (result) {
                var isSuccess = result.success;
                var errorMsg = result.msg;
                var content = "";
                if (eval(isSuccess)) {
                    content = "" +
                        '<div class="alert alert-success">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        '操作完成' +
                        '</div>';
                } else {
                    content = "" +
                        '<div class="alert alert-danger">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        JSON.stringify(errorMsg) +
                        '</div>';
                }
                $("#myModal").modal('hide');
                gridTable2.ajax.reload(null, false);
                $("#assignInfo").html(content).fadeIn(300).delay(2000).fadeOut(300);
            },
            error: function(data) {
                var errorContent = "" +
                    '<div class="alert alert-danger">' +
                    '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                    data.responseText +
                    '</div>';
                $("#assignInfo").html(errorContent);
                $("#assignInfo").html(errorContent).fadeIn(300).delay(2000).fadeOut(300);
            }
        });
    }
</script>