<div>
    <ul class="breadcrumb">
        <li>
            <a href="#">系统管理</a>
        </li>
        <li>
            <a href="#">系统日志</a>
        </li>
    </ul>
</div>
<div class="box-inner">
    <div class="box-header well" data-original-title="">
        <h2><i class="glyphicon glyphicon-user"></i> 系统日志</h2>
        <div class="box-icon">
            <a href="#" class="btn btn-minimize btn-round btn-default"><i
                    class="glyphicon glyphicon-chevron-up"></i></a>
            <a href="#" class="btn btn-close btn-round btn-default"><i
                    class="glyphicon glyphicon-remove"></i></a>
        </div>
    </div>
</div>
<div class="box-content">
    <div id="msgInfo" class="box-content alerts"></div>
    <table class="table table-striped table-bordered search_table" id="dataTable"></table>
</div>
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
                "url":"systemLog/list",
                "dataSrc": "data",
                "data": function ( d ) {
                    //添加额外的参数传给服务器
                    d.name = $("#name").val();
                }
            },
            "order": [[0, 'desc']], // 默认排序(第三列降序, asc升序)
            "columns": [
                { "title": "时间", "data" : "operationDate", "orderable": true, "searchable": false },
                { "title": "操作人", "data" : "operator", "orderable": true, "searchable": false },
                { "title": "操作内容", "data" : "operationMark", "orderable": true, "searchable": false },
                { "title": "IP", "data" : "loginIp", "orderable": true, "searchable": false },
                { "title": "类型", "data" : "type", "orderable": false, "searchable": false },
                { "title": "操作", "data" : function (data) {
                    return '<a class="btn btn-success" href="javascript:showInfo('+data.id+');" title="查看">' +
                           '<i class="glyphicon glyphicon-zoom-in icon-white"></i></a>';
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
    });

    function showInfo(id) {
        var url = '${createLink(controller: "systemLog", action: "show")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "id=" + id,
            success: function (result) {
                var content = "" +
                        '<div class="modal-header">' +
                        '<button type="button" class="close" data-dismiss="modal">×</button>' +
                        '<h3>系统日志详情</h3>' +
                        '</div>' +
                        '<div class="modal-body">' +
                        '<form id="infoForm" role="form">' +
                        '<div class="form-group">' +
                        '<label for="operationDate">时间</label>' +
                        '<input type="text" class="form-control" id="operationDate" name="operationDate" readonly="readonly" value="'+result.operationDate+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="operationMark">内容</label>' +
                        '<input type="text" class="form-control" id="operationMark" name="operationMark" readonly="readonly" value="'+result.operationMark+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="operator">操作人</label>' +
                        '<input type="text" class="form-control" id="operator" name="operator" readonly="readonly" value="'+result.operator+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="loginIp">IP</label>' +
                        '<input type="text" class="form-control" id="loginIp" name="loginIp" readonly="readonly" value="'+result.loginIp+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="remark">备注</label>' +
                        '<input type="text" class="form-control" id="remark" name="remark" readonly="readonly" value="'+result.remark+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="type">类型</label>' +
                        '<input type="text" class="form-control" id="type" name="type" readonly="readonly" value="'+result.type+'">' +
                        '</div>' +
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

</script>