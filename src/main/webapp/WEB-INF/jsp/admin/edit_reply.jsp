
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<head>

    <meta charset="utf-8">
    <title>Blog后台</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <link rel="stylesheet" href="http://www.sincenovember.top/static/layuiadmin/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="http://www.sincenovember.top/static/layuiadmin/style/admin.css" media="all">
    <link id="layuicss-layer" rel="stylesheet"
          href="http://www.sincenovember.top/static/layuiadmin/layui/css/modules/layer/default/layer.css?v=3.1.1"
          media="all">
</head>

<body layadmin-themealias="default">

<div class="layui-form" lay-filter="layuiadmin-form-useradmin" id="layuiadmin-form-useradmin"
     style="padding: 20px 0 0 0;">
    <div class="layui-form-item">
        <label class="layui-form-label">回复给:</label>
        <div class="layui-input-inline">
            <input type="text" id="tagName" value="${parentComment.commentName}" disabled="disabled" autocomplete="off" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">回复内容:</label>
        <div class="layui-input-inline">
                <textarea style="width: 245px; height: 100px;" lay-verify="phone" placeholder="请输入回复内容"
                          id="replyContent" autocomplete="off" class="layui-input">${comment.commentContent}</textarea>
        </div>
    </div>
    <div class="layui-form-item layui-hide">
        <input type="button" lay-submit="" lay-filter="LAY-user-front-submit" id="LAY-user-front-submit" value="确认">
    </div>
</div>


<script src="<%=request.getContextPath()%>/static/editor/js/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/static/layuiadmin/layui/layui.js"></script>

<script>
    var callbackdata = function () {
        var data = {
            commentContent: $("#replyContent").val(),
        };
        return data;
    }
</script>
<style id="LAY_layadmin_theme">
    .layui-side-menu,
    .layadmin-pagetabs .layui-tab-title li:after,
    .layadmin-pagetabs .layui-tab-title li.layui-this:after,
    .layui-layer-admin .layui-layer-title,
    .layadmin-side-shrink .layui-side-menu .layui-nav>.layui-nav-item>.layui-nav-child {
        background-color: #20222A !important;
    }

    .layui-nav-tree .layui-this,
    .layui-nav-tree .layui-this>a,
    .layui-nav-tree .layui-nav-child dd.layui-this,
    .layui-nav-tree .layui-nav-child dd.layui-this a {
        background-color: #009688 !important;
    }

    .layui-layout-admin .layui-logo {
        background-color: #20222A !important;
    }
</style>
</body>

</html>

