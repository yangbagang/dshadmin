<div>
    <ul class="breadcrumb">
        <li>
            <a href="#">项目资料</a>
        </li>
        <li>
            <a href="#">项目资料</a>
        </li>
    </ul>
</div>
<div class="box-inner">
    <div class="box-header well" data-original-title="">
        <h2><i class="glyphicon glyphicon-user"></i> 项目资料</h2>
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
                "url":"projectTaskData/listFiles",
                "dataSrc": "data",
                "data": function ( d ) {
                    //添加额外的参数传给服务器
                    d.name = $("#name").val();
                }
            },
            "order": [[5, 'desc']], // 默认排序(第三列降序, asc升序)
            "columns": [
                { "title": "项目", "data" : "project", "orderable": false, "searchable": false },
                { "title": "流程", "data" : "flow", "orderable": false, "searchable": false },
                { "title": "任务", "data" : "task", "orderable": false, "searchable": false },
                { "title": "文件名", "data" : "fileName", "orderable": true, "searchable": false },
                { "title": "文件大小", "data" : "fileSize", "orderable": true, "searchable": false },
                { "title": "上传时间", "data" : "createTime", "orderable": true, "searchable": false },
                { "title": "下载文件", "data" : function (data) {
                       return '<a href="'+ serverPath + 'download/'+data.value+'" target="_blank">下载</a>';
                    }, "orderable": false, "searchable": false },
                { "title": "预览", "data" : function (data) {
                        var isPdf = data.fileType.indexOf("pdf") != -1;
                        if (isPdf) {
                            var fileUrl = serverPath + 'download/'+data.value;
                            var viewUrl = "/dshadmin/static/bower_components/pdfjs/web/viewer.html?file="+fileUrl;
                            return '<a href="'+ viewUrl+'" target="_blank">预览</a>';
                        }
                        return '';
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
</script>