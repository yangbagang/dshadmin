<!-- content starts -->
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
        <h2><i class="glyphicon glyphicon-ok-sign"></i> Welcome</h2>

        <div class="box-icon">
            <a href="#" class="btn btn-setting btn-round btn-default"><i
                    class="glyphicon glyphicon-cog"></i></a>
            <a href="#" class="btn btn-minimize btn-round btn-default"><i
                    class="glyphicon glyphicon-chevron-up"></i></a>
            <a href="#" class="btn btn-close btn-round btn-default"><i
                    class="glyphicon glyphicon-remove"></i></a>
        </div>
    </div>
    <div class="box-content alerts">
        <div class="alert alert-info">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            欢迎 <strong><sec:loggedInUserInfo field='realName'/></strong> 再次回来。
        </div>
    </div>
</div>
<!-- content ends -->