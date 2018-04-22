<li class="accordion">
    <a href="#"><i class="glyphicon glyphicon-user"></i><span> 己完成项目</span></a>
    <ul class="nav nav-pills nav-stacked">
        <g:each in="${list2}" var="project">
            <li><a class="ajax-link" href="${createLink(uri: '/project/files', params: [projectId: project.id])}">${project.name}</a></li>
        </g:each>
    </ul>
</li>
<li class="accordion">
    <a href="#"><i class="glyphicon glyphicon-user"></i><span> 未完成项目</span></a>
    <ul class="nav nav-pills nav-stacked">
        <g:each in="${list1}" var="project">
            <li><a class="ajax-link" href="${createLink(uri: '/project/files', params: [projectId: project.id])}">${project.name}</a></li>
        </g:each>
    </ul>
</li>