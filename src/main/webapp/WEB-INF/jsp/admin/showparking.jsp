
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title>停车信息</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/style/admin.css" media="all">
</head>

<body>

<div class="layui-fluid">
    <div class="layui-row layui-col-space15">

        <div class="layui-fluid">
            <div class="layui-row" style="display: flex; gap: 15px;">
                <!-- 右侧 iframe -->
                <iframe
                        src="<%=request.getContextPath()%>/static/common/parking.jsp"
                        style="flex: 1; height: 400px; border: none; display: block;">
                </iframe>
                <!-- 左侧 iframe -->
                <iframe
                        src="<%=request.getContextPath()%>/static/common/vehicletype.jsp"
                        style="flex: 1; height: 400px; border: none; display: block;">
                </iframe>
                <iframe
                        src="<%=request.getContextPath()%>/static/common/license.jsp"
                        style="flex: 1; height: 400px; border: none; display: block;">
                </iframe>
            </div>
        </div>
    </div>
    <iframe
            src="<%=request.getContextPath()%>/static/common/animation.jsp"
            style="flex: 1; width: 90%; height: 160px; border: none; display: block; margin-left: 100px;">
    </iframe>
</div>

<script src="<%=request.getContextPath()%>/static/editor/js/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/static/layuiadmin/layui/layui.js"></script>

</body>
</html>
