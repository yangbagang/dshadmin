<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal">×</button>
    <h3>办理任务</h3>
</div>

<div class="modal-body">
    <form id="infoForm" role="form">
        <g:each in="${list}" var="data">
            <g:if test="${data.type == 'text'}">
                <div class="form-group">
                    <label for="${data.name}">${data.label}</label>
                    <input type="text" class="form-control" id="${data.name}" name="${data.name}" value="${data.value}"
                           placeholder="${data.label}" onblur="updateInfo(${data.id}, $('#msg_${data.id}'), this.value);">
                    <br/><div id="msg_${data.id}"></div>
                </div>
            </g:if>
            <g:if test="${data.type == 'file'}">
                <div class="form-group">
                    <label for="${data.name}">${data.label}</label>
                    <input type="file" class="form-control" id="${data.name}" name="${data.name}" placeholder="选择文件。"
                           onchange="postAjaxUpload(${data.id}, this, $('#msg_${data.id}'));">
                    <br/><div id="msg_${data.id}"></div>
                </div>
            </g:if>
        </g:each>
    </form>
</div>

<div class="modal-footer">
    <a href="#" class="btn btn-default" data-dismiss="modal">关闭</a>
</div>

<script>
var serverPath = 'http://183.57.41.230/FileServer/file/';
function postAjaxUpload(id, obj, msg) {
    $(msg).html("文件正在上传，请稍候。");
    var url = serverPath + 'upload';
    var data = new FormData();
    var file = obj.files[0];
    $("#type").val(file.type);
    $("#fileName").val(file.name);
    $("#fileSize").val(file.size);
    data.append('Filedata', file);
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
                $(msg).html("己上传。");
                updateFileInfo(id, msg, result.fid, file.name, file.type, file.size)
            } else {
                $("#uploadMsg").html(result.message);
            }
        },
        error: function(data) {
            $("#uploadMsgDiv").html(data.responseText);
        }
    });
}
function updateFileInfo(id, msg, value, fileName, fileType, fileSize) {
    var url = '${createLink(controller: "projectTaskData", action: "updateFile")}';
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url,
        data: "id=" + id + "&fileName=" + fileName + "&fileType=" + fileType + "&fileSize=" + fileSize + "&value=" + value,
        success: function (result) {
            var isSuccess = result.success;
            var errorMsg = result.msg;
            var content = "";
            if (eval(isSuccess)) {
                $(msg).html("己保存");
            } else {
                $(msg).html(JSON.stringify(errorMsg));
            }
        },
        error: function(data) {
            $(msg).html(data.responseText);
        }
    });
}
function updateInfo(id, msg, value) {
    var url = '${createLink(controller: "projectTaskData", action: "update")}';
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url,
        data: "id=" + id + "&value=" + value,
        success: function (result) {
            var isSuccess = result.success;
            var errorMsg = result.msg;
            var content = "";
            if (eval(isSuccess)) {
                $(msg).html("己保存");
            } else {
                $(msg).html(JSON.stringify(errorMsg));
            }
        },
        error: function(data) {
            $(msg).html(data.responseText);
        }
    });
}
</script>