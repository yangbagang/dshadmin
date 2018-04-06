<div>
    <ul class="breadcrumb">
        <li>
            <a href="#">Home</a>
        </li>
        <li>
            <a href="#">Dashboard</a>
        </li>
    </ul>
</div>
<div class="box-inner">
    <div class="box-header well">
        <h2><i class="glyphicon glyphicon-ok-sign"></i> 项目进展</h2>

        <div class="box-icon">
            <a href="#" class="btn btn-setting btn-round btn-default"><i
                    class="glyphicon glyphicon-cog"></i></a>
            <a href="#" class="btn btn-minimize btn-round btn-default"><i
                    class="glyphicon glyphicon-chevron-up"></i></a>
            <a href="#" class="btn btn-close btn-round btn-default"><i
                    class="glyphicon glyphicon-remove"></i></a>
        </div>
    </div>
    <div class="box-content">
        <ul class="nav nav-tabs" id="projectTab">
            <g:each in="${projectList}" var="project" status="i">
                <li><a href="javascript:changeTabContent(${i}, ${project.id});">${project.name}</a></li>
            </g:each>
        </ul>
        <div id="projectTabContent" class="tab-content">
            <div class="tab-pane active" id="projectInfo">

            </div>
        </div>
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
    var tab = $("#projectTab");
    var projectUrl = "${createLink(controller: 'project', action: 'view2')}";
    function changeTabContent(index, id) {
        tab.children("li").each(function (i, element) {
            if (i == index) {
                $(element).addClass("active");
            } else {
                $(element).removeClass("active");
            }
        });
        $.ajax({
            type: "get",
            url: projectUrl + "?projectId=" + id,
            success: function (result) {
                $("#projectInfo").html(result);
            }
        });
    }
    changeTabContent(0, ${projectList.first().id});
    function editTask(id, projectId) {
        console.log("taskId=" + id);
        var url = '${createLink(controller: "projectTaskData", action: "show2")}';
        $.ajax({
            type: "GET",
            url: url,
            data: "taskId=" + id + "&projectId=" + projectId,
            success: function (result) {
                var content = result;
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