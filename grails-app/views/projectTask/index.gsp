<div>
    <ul class="breadcrumb">
        <li>
            <a href="#">系统管理</a>
        </li>
        <li>
            <a href="#">管理员</a>
        </li>
    </ul>
</div>
<div class="box-inner">
    <div class="box-header well" data-original-title="">
        <h2><i class="glyphicon glyphicon-user"></i> 管理员</h2>
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
                "url":"projectTask/list",
                "dataSrc": "data",
                "data": function ( d ) {
                    //添加额外的参数传给服务器
                    d.taskName = $("#name").val();
                }
            },
            "order": [[4, 'desc']], // 默认排序(第三列降序, asc升序)
            "columns": [
                { "title": "任务名称", "data" : "taskName", "orderable": true, "searchable": false },
                { "title": "版本号", "data" : "taskVersion", "orderable": true, "searchable": false },
                { "title": "状态", "data" : "status", "orderable": true, "searchable": false },
                { "title": "建创时间", "data" : "createTime", "orderable": true, "searchable": false },
                { "title": "更新时间", "data" : "updateTime", "orderable": true, "searchable": false },
                { "title": "操作", "data" : function (data) {
                    return '<a class="btn btn-success" href="javascript:showInfo('+data.id+');" title="查看">' +
                            '<i class="glyphicon glyphicon-zoom-in icon-white"></i></a>&nbsp;&nbsp;' +
                            '<a class="btn btn-info" href="javascript:editInfo('+data.id+');" title="编辑">' +
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
        //查询 重新加载
        $("#searcher").click(function(){
            table.ajax.reload(null, false);
        });

    });

    function addInfo() {
        var content = "" +
                '<div class="modal-header">' +
                '<button type="button" class="close" data-dismiss="modal">×</button>' +
                '<h3>新建管理员</h3>' +
                '</div>' +
                '<div class="modal-body">' +
                '<form id="infoForm" role="form">' +
                '<div class="form-group">' +
                '<label for="username">用户名</label>' +
                '<input type="text" class="form-control" id="username" name="username" placeholder="用户名">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="realName">姓名</label>' +
                '<input type="text" class="form-control" id="realName" name="realName" placeholder="姓名">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="password">密码</label>' +
                '<input type="password" class="form-control" id="password" name="password" placeholder="密码">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="loginIp">邮箱</label>' +
                '<input type="email" class="form-control" id="email" name="email" placeholder="邮箱">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="enabled">启用</label>' +
                '<input type="checkbox" id="enableAccount" name="enableAccount" value="1">' +
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

    function showInfo(id) {
        var url = '${createLink(controller: "systemUser", action: "show")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "id=" + id,
            success: function (result) {
                var checkFlag = result.enabled ? 'checked="checked"' : '';
                var content = "" +
                        '<div class="modal-header">' +
                        '<button type="button" class="close" data-dismiss="modal">×</button>' +
                        '<h3>管理员详情</h3>' +
                        '</div>' +
                        '<div class="modal-body">' +
                        '<form id="infoForm" role="form">' +
                        '<div class="form-group">' +
                        '<label for="username">用户名</label>' +
                        '<input type="text" class="form-control" id="username" name="username" readonly="readonly" value="'+result.username+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="realName">姓名</label>' +
                        '<input type="text" class="form-control" id="realName" name="realName" readonly="readonly" value="'+result.realName+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="email">邮箱</label>' +
                        '<input type="email" class="form-control" id="email" name="email" readonly="readonly" value="'+result.email+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="createTime">创建时间</label>' +
                        '<input type="text" class="form-control" id="createTime" name="createTime" readonly="readonly" value="'+result.createTime+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="updateTime">最后更新时间</label>' +
                        '<input type="text" class="form-control" id="updateTime" name="updateTime" readonly="readonly" value="'+result.updateTime+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="enabled">启用</label>' +
                        '<input type="checkbox" id="enabled" name="enabled" disabled="disabled" ' + checkFlag + '></div>' +
                        '</form>' +
                        '</div>' +
                        '<div class="modal-footer">' +
                        '<a href="#" class="btn btn-default" data-dismiss="modal">关闭</a>' +
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

    function editInfo(id) {
        var url = '${createLink(controller: "systemUser", action: "show")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "id=" + id,
            success: function (result) {
                var checkFlag = result.enabled ? 'checked="checked"' : '';
                var content = "" +
                        '<div class="modal-header">' +
                        '<button type="button" class="close" data-dismiss="modal">×</button>' +
                        '<h3>编辑管理员</h3>' +
                        '</div>' +
                        '<div class="modal-body">' +
                        '<form id="infoForm" role="form">' +
                        '<input type="hidden" id="id" name="id" value="' + result.id + '">' +
                        '<div class="form-group">' +
                        '<label for="username">用户名</label>' +
                        '<input type="text" class="form-control" id="username" name="username" value="'+result.username+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="realName">姓名</label>' +
                        '<input type="text" class="form-control" id="realName" name="realName" value="'+result.realName+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="email">邮箱</label>' +
                        '<input type="text" class="form-control" id="email" name="email" value="'+result.email+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="password">密码</label>' +
                        '<input type="password" class="form-control" id="password" name="password" value="'+result.password+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="enableAccount">启用</label>' +
                        '<input type="checkbox" id="enableAccount" name="enableAccount" value="1" ' + checkFlag + '>' +
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
        var url = '${createLink(controller: "systemUser", action: "delete")}/' + id;
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
                            JSON.stringify(errorMsg) +
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
        var url = '${createLink(controller: "systemUser", action: "save")}';
        $.ajax({
            type: "POST",
            dataType: "json",
            url: url,
            data: $('#infoForm').serialize(),
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

</script>