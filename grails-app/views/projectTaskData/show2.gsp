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
                    <a href="javascript:removeItem(${data.id}, ${data.name});">[删除]</a>
                    <input type="text" class="form-control" id="${data.name}" name="${data.name}" value="${data.value}"
                           placeholder="${data.label}" onblur="updateInfo(${data.id}, $('#msg_${data.id}'), this.value);">
                    <br/><div id="msg_${data.id}"></div>
                </div>
            </g:if>
            <g:if test="${data.type == 'file'}">
                <div class="form-group">
                    <label for="${data.name}">${data.label}</label>
                    <g:if test="${data.value != ''}">[${data.fileName}]</g:if>
                    <a href="javascript:removeItem(${data.id}, ${data.name});">[删除]</a>
                    <input type="file" class="form-control" id="${data.name}" name="${data.name}" placeholder="选择文件。"
                           onchange="postAjaxUpload(${data.id}, this, $('#msg_${data.id}'));">
                    <br/><div id="msg_${data.id}"></div>
                </div>
            </g:if>
        </g:each>
    </form>
</div>

<div class="modal-footer">
    <a href="javascript:createFileItem(${taskId});" class="btn btn-primary">新增文件</a>&nbsp;&nbsp;
    <a href="javascript:createTextItem(${taskId});" class="btn btn-primary">新增文本</a>&nbsp;&nbsp;
    <a href="#" class="btn btn-default" data-dismiss="modal">关闭</a>&nbsp;&nbsp;
    <a class="btn btn-info" href="javascript:postAjaxForm(${taskId}, ${projectId});" title="提交">完成</a>
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
function createFileItem(taskId) {
    var url = '${createLink(controller: "projectTaskData", action: "createFile")}';
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url,
        data: "taskId=" + taskId,
        success: function (result) {
            if (result.id != undefined && result.id != null && result.id != "") {
                var item = "<div class=\"form-group\">" +
                    "<label for=\"file_"+result.id+"\">新增文件</label>" +
                    "<input type=\"file\" class=\"form-control\" id=\"file_"+result.id+"\" name=\"file_"+result.id+"\" placeholder=\"选择文件。\" " +
                    "onchange=\"postAjaxUpload("+result.id+", this, $('#msg_"+result.id+"'));\">\n" +
                    "<br/><div id=\"msg_"+result.id+"\"></div>\n" +
                    "</div>";
                $("#infoForm").append(item);
            }
        }
    });
}
function createTextItem(taskId) {
    var url = '${createLink(controller: "projectTaskData", action: "createText")}';
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url,
        data: "taskId=" + taskId,
        success: function (result) {
            if (result.id != undefined && result.id != null && result.id != "") {
                var item = "<div class=\"form-group\">" +
                    "<label for=\"text_"+result.id+"\">新增文本</label>" +
                    "<input type=\"text\" class=\"form-control\" id=\"text_"+result.id+"\" name=\"text_"+result.id+"\"  " +
                    "onblur=\"updateInfo("+result.id+", $('#msg_"+result.id+"'), this.value);\">\n" +
                    "<br/><div id=\"msg_"+result.id+"\"></div>\n" +
                    "</div>";
                $("#infoForm").append(item);
            }
        }
    });
}
function removeItem(id, obj) {
    var url = '${createLink(controller: "projectTaskData", action: "remove")}';
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url,
        data: "id=" + id,
        success: function (result) {
            $(obj).parent(".form-group").remove();
        }
    });
}

function postAjaxForm(taskId, projectId) {
    var url = '${createLink(controller: "projectTask", action: "complete")}';
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url,
        data: "taskId=" + taskId,
        success: function (result) {
            var isSuccess = result.success;
            var errorMsg = result.msg;
            var content = "";
            if (isSuccess) {
                loadProjectFlow(projectId);
                $("#myModal").modal('hide');
            } else {
                alert(errorMsg);
            }
        }
    });
}
</script>