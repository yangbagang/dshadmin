<div>
    <ul class="breadcrumb">
        <li>
            <a href="#">项目管理</a>
        </li>
        <li>
            <a href="#">项目管理</a>
        </li>
    </ul>
</div>
<div class="box-inner">
    <div class="box-header well" data-original-title="">
        <h2><i class="glyphicon glyphicon-user"></i> 项目管理</h2>
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
            <label class="control-label" for="name">名称:</label>
            <input type="text" class="form-control" id="name">
            <input type="button" class="btn btn-primary" value="查询" id="searcher"/>
        </div>
    </form><br />
    <div id="msgInfo" class="box-content alerts"></div>
    <table class="table table-striped table-bordered search_table" id="dataTable"></table>
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
                "url":"project/list",
                "dataSrc": "data",
                "data": function ( d ) {
                    //添加额外的参数传给服务器
                    d.name = $("#name").val();
                }
            },
            "order": [[0, 'asc']], // 默认排序(第三列降序, asc升序)
            "columns": [
                { "title": "名称", "data" : "name", "orderable": true, "searchable": false },
                { "title": "备注", "data" : "memo", "orderable": true, "searchable": false },
                { "title": "创建者", "data" : "createUser", "orderable": true, "searchable": false },
                { "title": "创建时间", "data" : "createTime", "orderable": true, "searchable": false },
                { "title": "更新者", "data" : "updateUser", "orderable": true, "searchable": false },
                { "title": "更新时间", "data" : "updateTime", "orderable": true, "searchable": false },
                { "title": "当前节点", "data" : "taskName", "orderable": true, "searchable": false },
                { "title": "当前状态", "data" : function (data) {
                        if (data.status == 0) return "未启动";
                        if (data.status == 1) return "进行中";
                        if (data.status == 2) return "己完成";
                        if (data.status == 9) return "己中止";
                        return "其它";
                    }, "orderable": true, "searchable": false },
                { "title": "查看", "data" : function (data) {
                        var u = '${createLink(controller: "project", action: "view")}';
                        return '<a href="'+u+'?projectId='+data.id+'" target="_blank">查看</a>';
                    }, "orderable": false, "searchable": false },
                { "title": "操作", "data" : function (data) {
                    return '<a class="btn btn-success" href="javascript:startProject('+data.id+');" title="启动">' +
                            '<i class="glyphicon glyphicon-play icon-white"></i></a>&nbsp;&nbsp;' +
                            '<a class="btn btn-info" href="javascript:editInfo('+data.id+');" title="编辑">' +
                            '<i class="glyphicon glyphicon-edit icon-white"></i></a>&nbsp;&nbsp;' +
                            '<a class="btn btn-danger" href="javascript:removeInfo('+data.id+');" title="中止">' +
                            '<i class="glyphicon glyphicon-stop icon-white"></i></a>&nbsp;&nbsp;' +
                            '<a class="btn btn-danger" href="javascript:deleteInfo('+data.id+');" title="删除">' +
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
        //查询 重新加载
        $("#searcher").click(function(){
            table.ajax.reload(null, false);
        });

    });

    function addInfo() {
        <sec:ifNotGranted roles='ROLE_SUPER_ADMIN,ROLE_PROJECT_ADMIN'>
        alert("权限限制，请联系管理员添加权限。");
        return;
        </sec:ifNotGranted>
        var content = "" +
                '<div class="modal-header">' +
                '<button type="button" class="close" data-dismiss="modal">×</button>' +
                '<h3>新建项目</h3>' +
                '</div>' +
                '<div class="modal-body">' +
                '<form id="infoForm" role="form">' +
                '<div class="form-group">' +
                '<label for="name">名称</label>' +
                '<input type="text" class="form-control" id="name" name="name" placeholder="项目名称">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="memo">备注</label>' +
                '<input type="text" class="form-control" id="memo" name="memo" placeholder="备注">' +
                '</div>' +
                '<div class="control-group">' +
                '<label class="control-label" for="workFlowId">工作流</label>' +
                '<div class="controls">' +
                '<select id="workFlowId" name="workFlowId" class="form-control" data-rel="chosen"></select>' +
                '</div>' +
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
        loadWorkFlowList(0);
    }

    function startProject(id) {
        <sec:ifNotGranted roles='ROLE_SUPER_ADMIN,ROLE_PROJECT_ADMIN'>
        alert("权限限制，请联系管理员添加权限。");
        return;
        </sec:ifNotGranted>
        var url = '${createLink(controller: "project", action: "start")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "id=" + id,
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
            error: function (data) {
                showErrorInfo(data.responseText);
            }
        });
    }

    function editInfo(id) {
        <sec:ifNotGranted roles='ROLE_SUPER_ADMIN,ROLE_PROJECT_ADMIN'>
        alert("权限限制，请联系管理员添加权限。");
        return;
        </sec:ifNotGranted>
        var url = '${createLink(controller: "project", action: "show")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "id=" + id,
            success: function (result) {
                var content = "" +
                        '<div class="modal-header">' +
                        '<button type="button" class="close" data-dismiss="modal">×</button>' +
                        '<h3>编辑项目</h3>' +
                        '</div>' +
                        '<div class="modal-body">' +
                        '<form id="infoForm" role="form">' +
                        '<input type="hidden" id="id" name="id" value="' + result.id + '">' +
                        '<div class="form-group">' +
                        '<label for="name">名称</label>' +
                        '<input type="text" class="form-control" id="name" name="name" value="'+result.name+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="memo">备注</label>' +
                        '<input type="text" class="form-control" id="memo" name="memo" value="'+result.memo+'">' +
                        '</div>' +
                        '<div class="control-group">' +
                        '<label class="control-label" for="workFlowId">工作流</label>' +
                        '<div class="controls">' +
                        '<select id="workFlowId" name="workFlowId" class="form-control" data-rel="chosen"></select>' +
                        '<br/><div>项目启动后再更变此项将不会产生效果。</div>' +
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
                loadWorkFlowList(result.workFlowId)
            },
            error: function (data) {
                showErrorInfo(data.responseText);
            }
        });
    }

    function removeInfo(id) {
        <sec:ifNotGranted roles='ROLE_SUPER_ADMIN,ROLE_PROJECT_ADMIN'>
        alert("权限限制，请联系管理员添加权限。");
        return;
        </sec:ifNotGranted>
        var content = "" +
            '<div class="modal-header">' +
            '<button type="button" class="close" data-dismiss="modal">×</button>' +
            '<h3>提示</h3>' +
            '</div>' +
            '<div class="modal-body">' +
            '<p>此操作将中止项目进行，此项目中的所有任务都将结束,是否继续?</p>' +
            '</div>' +
            '<div class="modal-footer">' +
            '<a href="#" class="btn btn-default" data-dismiss="modal">取消</a>' +
            '<a href="javascript:postAjaxRemove('+id+');" class="btn btn-primary">中止</a>' +
            '</div>';
        $("#modal-content").html("");
        $("#modal-content").html(content);
        $('#myModal').modal('show');
    }

    function postAjaxRemove(id) {
        var url = '${createLink(controller: "project", action: "delete")}/' + id;
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
                        '操作完成' +
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

    function deleteInfo(id) {
        <sec:ifNotGranted roles='ROLE_SUPER_ADMIN,ROLE_PROJECT_ADMIN'>
        alert("权限限制，请联系管理员添加权限。");
        return;
        </sec:ifNotGranted>
        var content = "" +
            '<div class="modal-header">' +
            '<button type="button" class="close" data-dismiss="modal">×</button>' +
            '<h3>提示</h3>' +
            '</div>' +
            '<div class="modal-body">' +
            '<p>此操作将删除项目所有资料、数据并且不可恢复，是否继续?</p>' +
            '</div>' +
            '<div class="modal-footer">' +
            '<a href="#" class="btn btn-default" data-dismiss="modal">取消</a>' +
            '<a href="javascript:postAjaxDelete('+id+');" class="btn btn-primary">删除</a>' +
            '</div>';
        $("#modal-content").html("");
        $("#modal-content").html(content);
        $('#myModal').modal('show');
    }

    function postAjaxDelete(id) {
        var url = '${createLink(controller: "project", action: "remove")}/' + id;
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
                        '操作完成' +
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
        var url = '${createLink(controller: "project", action: "save")}';
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
                $("#msgInfo").html(errorContent).fadeIn(300).delay(2000).fadeOut(300);
            }
        });
    }

    function loadWorkFlowList(workId) {
        var url = '${createLink(controller: "workFlow", action: "flowList")}';
        $.ajax({
            type: "get",
            dataType: "json",
            url: url,
            data: "",
            success: function (result) {
                $("#workFlowId").empty();
                $.each(result, function (index, item) {
                    $("#workFlowId").append("<option value='"+item.flowId+"' " +
                        getSelectedFlag(item.flowId, workId) + ">"+item.flowName+"</option>");
                });
            },
            error: function (data) {
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

    function getSelectedFlag(value1, value2) {
        if (value1 == value2){
            return "selected=selected";
        }
        return "";
    }
</script>