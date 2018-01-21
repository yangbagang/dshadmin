<div>
    <ul class="breadcrumb">
        <li>
            <a href="#">流程管理</a>
        </li>
        <li>
            <a href="#">流程设置</a>
        </li>
    </ul>
</div>
<div class="box-inner">
    <div class="box-header well" data-original-title="">
        <h2><i class="glyphicon glyphicon-user"></i> 流程设置</h2>
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
                "url":"flowDefinition/list",
                "dataSrc": "data",
                "data": function ( d ) {
                    //添加额外的参数传给服务器
                    d.name = $("#name").val();
                }
            },
            "order": [[3, 'desc']], // 默认排序(第三列降序, asc升序)
            "columns": [
                { "title": "名称", "data" : "name", "orderable": true, "searchable": false },
                { "title": "备注", "data" : "memo", "orderable": true, "searchable": false },
                { "title": "上一流程", "data" : "prevName", "orderable": true, "searchable": false },
                { "title": "更新时间", "data" : "createTime", "orderable": true, "searchable": false },
                { "title": "工作流", "data" : "workFlow", "orderable": false, "searchable": false },
                { "title": "操作", "data" : function (data) {
                    return '<a class="btn btn-success" href="flowDefinition/design?flowId='+data.id+'" title="设计" target="_blank">' +
                            '<i class="glyphicon glyphicon-zoom-in icon-white"></i></a>&nbsp;&nbsp;' +
                            '<a class="btn btn-info" href="javascript:editInfo('+data.id+');" title="编辑">' +
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
                '<h3>新建流程</h3>' +
                '</div>' +
                '<div class="modal-body">' +
                '<form id="infoForm" role="form">' +
                '<div class="form-group">' +
                '<label for="name">名称</label>' +
                '<input type="text" class="form-control" id="name" name="name" placeholder="名称">' +
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
                '<div class="control-group">' +
                '<label class="control-label" for="prevId">上一流程</label>' +
                '<div class="controls">' +
                '<select id="prevId" name="prevId" class="form-control" data-rel="chosen"></select>' +
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
        loadDefinitionList(0);
    }

    function editInfo(id) {
        var url = '${createLink(controller: "flowDefinition", action: "show")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "id=" + id,
            success: function (result) {
                var content = "" +
                        '<div class="modal-header">' +
                        '<button type="button" class="close" data-dismiss="modal">×</button>' +
                        '<h3>编辑流程</h3>' +
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
                        '</div>' +
                        '</div>' +
                        '<div class="control-group">' +
                        '<label class="control-label" for="prevId">上一流程</label>' +
                        '<div class="controls">' +
                        '<select id="prevId" name="prevId" class="form-control" data-rel="chosen"></select>' +
                        '</div>' +
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
                loadWorkFlowList(result.workFlowId);
                loadDefinitionList(result.prevId);
            },
            error: function (data) {
                showErrorInfo(data.responseText);
            }
        });
    }

    function postAjaxForm() {
        var url = '${createLink(controller: "flowDefinition", action: "save")}';
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

    function loadDefinitionList(flowId) {
        var url = '${createLink(controller: "flowDefinition", action: "flowList")}';
        $.ajax({
            type: "get",
            dataType: "json",
            url: url,
            data: "",
            success: function (result) {
                $("#prevId").empty();
                $("#prevId").append("<option value='0'>无</option>");
                $.each(result, function (index, item) {
                    $("#prevId").append("<option value='"+item.flowId+"' " +
                        getSelectedFlag(item.flowId, flowId) + ">"+item.flowName+"</option>");
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