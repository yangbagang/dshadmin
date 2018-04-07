<div>
    <ul class="breadcrumb">
        <li>
            <a href="#">法律法规</a>
        </li>
        <li>
            <a href="#">法律法规</a>
        </li>
    </ul>
</div>
<div class="box-inner">
    <div class="box-header well" data-original-title="">
        <h2><i class="glyphicon glyphicon-user"></i> 法律法规</h2>
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
            <label class="control-label" for="name">关键词:</label>
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
    var serverPath = 'http://183.57.41.230/FileServer/file/';
    var fileHasChanged = false;
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
                "url":"fileInfo/list",
                "dataSrc": "data",
                "data": function ( d ) {
                    //添加额外的参数传给服务器
                    d.name = $("#name").val();
                }
            },
            "order": [[1, 'desc']], // 默认排序(第三列降序, asc升序)
            "columns": [
                { "title": "标题", "data" : "title", "orderable": true, "searchable": false },
                { "title": "添加时间", "data" : "createTime", "orderable": true, "searchable": false },
                { "title": "文件名", "data" : "fileName", "orderable": true, "searchable": false },
                { "title": "文件大小", "data" : "fileSize", "orderable": true, "searchable": false },
                { "title": "备注", "data" : "memo", "orderable": true, "searchable": false },
                { "title": "下载", "data" : function (data) {
                       return '<a href="'+ serverPath + 'download/'+data.fileId+'" target="_blank">下载</a>';
                    }, "orderable": false, "searchable": false },
                { "title": "预览", "data" : function (data) {
                    var isPdf = data.type.indexOf("pdf") != -1;
                    if (isPdf) {
                        var fileUrl = serverPath + 'download/'+data.fileId;
                        var viewUrl = "/dshadmin/static/bower_components/pdfjs/web/viewer.html?file="+fileUrl;
                        return '<a href="'+ viewUrl+'" target="_blank">预览</a>';
                    }
                    var fileName = data.filename.toLowerCase();
                    if (fileName.indexOf(".doc") != -1 || fileName.indexOf(".ppt") != -1 || fileName.indexOf(".xls") != -1) {
                        var fileUrl = serverPath + 'download/'+data.fileId;
                        var viewUrl = "http://ow365.cn/?i=15368&furl="+fileUrl;
                        return '<a href="'+ viewUrl+'" target="_blank">预览</a>';
                    }
                    return '';
                    }, "orderable": false, "searchable": false },
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
        <sec:ifNotGranted roles='ROLE_SUPER_ADMIN,ROLE_FILE_ADMIN'>
        alert("权限限制，请联系管理员添加权限。");
        return;
        </sec:ifNotGranted>
        var content = "" +
                '<div class="modal-header">' +
                '<button type="button" class="close" data-dismiss="modal">×</button>' +
                '<h3>添加资料</h3>' +
                '</div>' +
                '<div class="modal-body">' +
                '<form id="infoForm" role="form">' +
                '<input type="hidden" id="type" name="type" value="">' +
                '<input type="hidden" id="fileId" name="fileId" value="">' +
                '<input type="hidden" id="fileName" name="fileName" value="">' +
                '<input type="hidden" id="fileSize" name="fileSize" value="0">' +
                '<div class="form-group">' +
                '<label for="Filedata">文件</label>' +
                '<input type="file" class="form-control" id="Filedata" name="Filedata" placeholder="选择文件。" onchange="getFileInfo(this);">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="title">标题</label>' +
                '<input type="text" class="form-control" id="title" name="title" placeholder="标题">' +
                '</div>' +
                '<div class="form-group">' +
                '<label for="memo">备注</label>' +
                '<input type="text" class="form-control" id="memo" name="memo" placeholder="备注">' +
                '</div>' +
                '</form>' +
                '</div>' +
                '<div class="modal-footer">' +
                '<a href="#" class="btn btn-default" data-dismiss="modal">关闭</a>' +
                '<a href="javascript:postAjaxUpload();" class="btn btn-primary">保存</a>' +
                '<br><div id="uploadMsg"></div>' +
                '</div>';
        $("#modal-content").html("");
        $("#modal-content").html(content);
        $('#myModal').modal('show');
    }

    function getFileInfo(obj) {
        var file = obj.files[0];
        $("#type").val(file.type);
        $("#fileName").val(file.name);
        $("#fileSize").val(file.size);
        fileHasChanged = true;
    }

    function showInfo(id) {
        var url = '${createLink(controller: "fileInfo", action: "show")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "id=" + id,
            success: function (result) {
                var content = "" +
                        '<div class="modal-header">' +
                        '<button type="button" class="close" data-dismiss="modal">×</button>' +
                        '<h3>资料详情</h3>' +
                        '</div>' +
                        '<div class="modal-body">' +
                        '<form id="infoForm" role="form">' +
                        '<div class="form-group">' +
                        '<label for="title">标题</label>' +
                        '<input type="text" class="form-control" id="title" name="title" readonly="readonly" value="'+result.title+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="memo">备注</label>' +
                        '<input type="text" class="form-control" id="memo" name="memo" readonly="readonly" value="'+result.memo+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="type">类型</label>' +
                        '<input type="text" class="form-control" id="type" name="type" readonly="readonly" value="'+result.type+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="fileName">文件名</label>' +
                        '<input type="text" class="form-control" id="fileName" name="fileName" readonly="readonly" value="'+result.fileName+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="fileSize">文件大小</label>' +
                        '<input type="text" class="form-control" id="fileSize" name="fileSize" readonly="readonly" value="'+result.fileSize+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="createTime">添加时间</label>' +
                        '<input type="text" class="form-control" id="createTime" name="createTime" readonly="readonly" value="'+result.createTime+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="downloadFile">下载文件</label>' +
                        '<a id="downloadFile" href="'+ serverPath + 'download/'+result.fileId+'">点此下载</a>' +
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

    function editInfo(id) {
        <sec:ifNotGranted roles='ROLE_SUPER_ADMIN,ROLE_FILE_ADMIN'>
        alert("权限限制，请联系管理员添加权限。");
        return;
        </sec:ifNotGranted>
        var url = '${createLink(controller: "fileInfo", action: "show")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "id=" + id,
            success: function (result) {
                var content = "" +
                        '<div class="modal-header">' +
                        '<button type="button" class="close" data-dismiss="modal">×</button>' +
                        '<h3>编辑资料</h3>' +
                        '</div>' +
                        '<div class="modal-body">' +
                        '<form id="infoForm" role="form">' +
                        '<input type="hidden" id="id" name="id" value="' + result.id + '">' +
                        '<input type="hidden" id="type" name="type" value="' + result.type + '">' +
                        '<input type="hidden" id="fileId" name="fileId" value="' + result.fileId + '">' +
                        '<input type="hidden" id="fileName" name="fileName" value="' + result.fileName + '">' +
                        '<input type="hidden" id="fileSize" name="fileSize" value="' + result.fileSize + '">' +
                        '<div class="form-group">' +
                        '<label for="title">标题</label>' +
                        '<input type="text" class="form-control" id="title" name="title" value="'+result.title+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="memo">备注</label>' +
                        '<input type="text" class="form-control" id="memo" name="memo" value="'+result.memo+'">' +
                        '</div>' +
                        '<div class="form-group">' +
                        '<label for="Filedata">文件</label>' +
                        '<input type="file" class="form-control" id="Filedata" name="Filedata" onchange="getFileInfo(this);">' +
                        '</div>' +
                        '</form>' +
                        '</div>' +
                        '<div class="modal-footer">' +
                        '<a href="#" class="btn btn-default" data-dismiss="modal">关闭</a>' +
                        '<a href="javascript:postAjaxUpload();" class="btn btn-primary">更新</a>' +
                        '<br><div id="uploadMsg"></div>' +
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
        <sec:ifNotGranted roles='ROLE_SUPER_ADMIN,ROLE_FILE_ADMIN'>
        alert("权限限制，请联系管理员添加权限。");
        return;
        </sec:ifNotGranted>
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
        var url = '${createLink(controller: "fileInfo", action: "delete")}/' + id;
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
        var url = '${createLink(controller: "fileInfo", action: "save")}';
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

    function postAjaxUpload() {
        if (!fileHasChanged) {
            postAjaxForm();
            return;
        }
        $("#uploadMsg").html("文件正在上传，请勿重复点击。");
        var url = serverPath + 'upload';
        var data = new FormData();
        data.append('Filedata', $("#Filedata")[0].files[0]);
        data.append('folder', 'dsh');
        $.ajax({
            type: "POST",
            dataType: "json",
            url: url,
            data: data,
            cache: false,
            contentType: false,
            processData: false,
            success: function (result) {
                if (result.status == 200) {
                    $("#fileId").val(result.fid);
                    postAjaxForm();
                } else {
                    $("#uploadMsg").html(result.message);
                }
            },
            error: function(data) {
                $("#uploadMsgDiv").html(data.responseText);
            }
        });
    }

</script>