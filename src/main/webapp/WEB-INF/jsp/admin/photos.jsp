<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<meta charset="utf-8">
<title>Blog后台</title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport"
      content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
<link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/layui/css/layui.css" media="all">
<link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/style/admin.css" media="all">

<body>
<!--    列表 -->
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>所有相册</legend>
        </fieldset>
        <div class="layui-tab layui-tab-card">
            <a lay-href="<%=request.getContextPath()%>/admin/photos/info">
                <i class="layui-icon layui-icon-form"></i>
                添加
            </a>
            <form id="articleForm" method="post">
                <input type="hidden" name="currentUrl" id="currentUrl" value="">
                <table class="layui-table">
                    <colgroup>
                        <col width="100">
                        <col width="100">
                        <col width="200">
                    </colgroup>
                    <thead>
                    <tr>
                        <th style="text-align:center;">图片名称</th>
                        <th style="text-align:center;">图片</th>
                        <th style="text-align:center;">操作</th>
                    </tr>
                    </thead>
                    <tbody>

                    <c:forEach items="${photos}" var="photos">


                        <tr>
                            <td align="center">
                                    ${photos.photoName}
                            </td>
                            <td align="center">
                                <img id="myImage" src="<%=request.getContextPath()%>${photos.photoPic}">
                            </td>
                            <td align="center">
                                <button type="button" class="layui-btn layui-btn-danger layui-btn-mini" id="del"
                                        data-type="remove" data-index="${photos.id}">删除</button>
                            </td>
                        </tr>

                    </c:forEach>


                    </tbody>

                </table>




                <div class="layui-card-body" align="center">
                    <div id="test-laypage-demo1">
                        <div class="layui-box layui-laypage layui-laypage-default" id="layui-laypage-2">


                            <a class="layui-laypage-prev layui-disabled">首页</a>
                            <a class="layui-laypage-prev layui-disabled">上一页</a>


                            <span class="layui-laypage-curr" style="background-color:#009688;"><em>1</em></span>
                            <!--<a href="/admin/photos/2">下一页</a>-->
                            <a onclick="next()">下一页</a>
                            <script type="text/javascript">
                                function next() {
                                    alert("已到最后一页！");
                                }
                            </script>
                            <a href="/admin/photos/84">尾页</a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="<%=request.getContextPath()%>/static/editor/js/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/static/layuiadmin/layui/layui.js"></script>
<script>
    layui.config({
        base: '<%=request.getContextPath()%>/static/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'useradmin', 'table'], function () {
        var $ = layui.$,
            form = layui.form,
            table = layui.table;
    });
</script>


<script>
    $("[id=del]").on("click", function () {
        var id = $(this).attr('data-index');
        var t = $(this).parent().parent();
        layer.confirm('确定要删除？', {
            btn: ['确认', '取消'] //按钮
        }, function () {
            $.post('<%=request.getContextPath()%>/admin/photos/delete/' + id, {
            }, function (data) {
                if (data.state == 1) {
                    layer.alert("删除成功",{icon:1},function () {
                        window.location.reload();
                    })

                } else {
                    layer.alert("删除失败", {icon: 5});
                }
            }, 'json');
        });
    });
</script>


</body>
</html>
