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
            <a href="javascript:addInfo();" class="btn btn-plus btn-round btn-default"><i
                    class="glyphicon glyphicon-plus"></i></a>
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
        <h2><i class="glyphicon glyphicon-user"></i> 绑定操作人</h2>
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
            <input type="button" value="绑定" onclick="addAssign();">
        </div>
    </form><br />
    <div id="assignInfo" class="box-content alerts"></div>
    <table class="table table-striped table-bordered search_table" id="dataTable2"></table>
</div>

<div class="box-inner">
    <div class="box-header well" data-original-title="">
        <h2><i class="glyphicon glyphicon-user"></i> 表单配置</h2>
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
            "paginate": true,
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
                    return  '<a class="btn btn-info" href="javascript:loadInfo('+data.id+');" title="编辑">' +
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
            "paginate": true,
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
            "paginate": true,
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
                { "title": "英文名", "data" : "name", "orderable": true, "searchable": false },
                { "title": "中文名", "data" : "flowName", "orderable": false, "searchable": false },
                { "title": "类型", "data" : "type", "orderable": true, "searchable": false },
                { "title": "是否空白", "data" : "isBlank", "orderable": true, "searchable": false },
                { "title": "是否隐藏", "data" : "isHidden", "orderable": true, "searchable": false },
                { "title": "操作", "data" : function (data) {
                        return '<a class="btn btn-info" href="javascript:editInfo('+data.id+');" title="编辑">' +
                            '<i class="glyphicon glyphicon-edit icon-white"></i></a>&nbsp;&nbsp;' +
                            '<a class="btn btn-danger" href="javascript:removeInfo('+data.id+');" title="删除">' +
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
            }
        });
        //默认查询
        gridTable.ajax.reload(null, false);
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

    function loadInfo(id) {
        taskId = id;
        gridTable2.ajax.reload(null, false);
        gridTable3.ajax.reload(null, false);
    }

    function addInfo() {
        var content = "" +
                '<div class="modal-header">' +
                '<button type="button" class="close" data-dismiss="modal">×</button>' +
                '<h3>新建角色</h3>' +
                '</div>' +
                '<div class="modal-body">' +
                '<form id="infoForm" role="form">' +
                '<div class="form-group">' +
                '<label for="authority">权限</label>' +
                '<input type="text" class="form-control" id="authority" name="authority" placeholder="权限英文值,非随意值。">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="roleName">角色名</label>' +
                '<input type="text" class="form-control" id="roleName" name="roleName" placeholder="角色名">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="remark">备注</label>' +
                '<input type="text" class="form-control" id="remark" name="remark" placeholder="备注">' +
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

    function editInfo(id) {
        var url = '${createLink(controller: "systemRole", action: "show")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "id=" + id,
            success: function (result) {
                var content = "" +
                        '<div class="modal-header">' +
                        '<button type="button" class="close" data-dismiss="modal">×</button>' +
                        '<h3>编辑角色</h3>' +
                        '</div>' +
                        '<div class="modal-body">' +
                        '<form id="infoForm" role="form">' +
                        '<input type="hidden" id="id" name="id" value="' + result.id + '">' +
                        '<div class="form-group">' +
                        '<label for="authority">权限值</label>' +
                        '<input type="text" class="form-control" id="authority" name="authority" value="'+result.authority+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="roleName">角色名</label>' +
                        '<input type="text" class="form-control" id="roleName" name="roleName" value="'+result.roleName+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="remark">备注</label>' +
                        '<input type="text" class="form-control" id="remark" name="remark" value="'+result.remark+'">' +
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
            },
            error: function (data) {
                showErrorInfo(data.responseText);
            }
        });
    }

    function removeInfo(id) {
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
        var url = '${createLink(controller: "systemRole", action: "delete")}/' + id;
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
                gridTable.ajax.reload(null, false);
                $("#msgInfo").html(content);
                $("#msgInfo").html(content).fadeIn(300).delay(2000).fadeOut(300);
            },
            error: function (data) {
                var errorContent = "" +
                        '<div class="alert alert-danger">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        data.responseText +
                        '</div>';
                $("#msgInfo").html(errorContent);
                $("#msgInfo").html(errorContent).fadeIn(300).delay(2000).fadeOut(300);
            }
        });
    }

    function postAjaxForm() {
        var url = '${createLink(controller: "systemRole", action: "save")}';
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
                gridTable.ajax.reload(null, false);
                $("#msgInfo").html(content).fadeIn(300).delay(2000).fadeOut(300);
            },
            error: function(data) {
                var errorContent = "" +
                        '<div class="alert alert-danger">' +
                        '<button type="button" class="close" data-dismiss="alert">&times;</button>' +
                        data.responseText +
                        '</div>';
                $("#msgInfo").html(errorContent);
                $("#msgInfo").html(content).fadeIn(300).delay(2000).fadeOut(300);
            }
        });
    }

</script>