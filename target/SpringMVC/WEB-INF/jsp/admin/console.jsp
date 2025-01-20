<%@ page import="java.sql.*" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Properties" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 加载 jdbc.properties 配置文件
    Properties properties = new Properties();
    InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
    properties.load(inputStream);
    String url = properties.getProperty("url");
    String dbUsername = properties.getProperty("user");
    String dbPassword = properties.getProperty("password");
    String dbDriver = properties.getProperty("driver");
    // 加载MySQL的JDBC驱动程序
    Class.forName(dbDriver);
    // 建立数据库连接
    Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword);
    // 查询剩余停车位数
    String availableParkingSql = "SELECT COUNT(*) FROM parking_spot WHERE status = 'FREE'";
    PreparedStatement availableParkingStmt = conn.prepareStatement(availableParkingSql);
    ResultSet availableParkingRs = availableParkingStmt.executeQuery();
    int availableParkingCount = 0;
    if (availableParkingRs.next()) {
        availableParkingCount = availableParkingRs.getInt(1);
    }

    // 查询名下车辆数
    String vehiclesSql = "SELECT COUNT(*) FROM vehicles ";
    PreparedStatement vehiclesStmt = conn.prepareStatement(vehiclesSql);
    ResultSet vehiclesRs = vehiclesStmt.executeQuery();
    int vehiclesCount = 0;
    if (vehiclesRs.next()) {
        vehiclesCount = vehiclesRs.getInt(1);
    }

%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title>Blog后台</title>
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

        <div class="layui-col-sm6 layui-col-md3">
            <div class="layui-card">
                <div class="layui-card-header">
                    新增访问量
                    <span><i class="layui-inline layui-icon layui-icon-release" style="color:#1e9fff"></i></span>
                </div>
                <div class="layui-card-body layuiadmin-card-list">
                    <p class="layuiadmin-big-font">2</p>
                    <p>
                        总计访问量
                        <span class="layuiadmin-span-color">755<i
                                class="layui-inline layui-icon layui-icon-flag"></i></span>
                    </p>
                </div>
            </div>
        </div>

        <!-- 第二个框：剩余停车位 -->
        <div class="layui-col-sm6 layui-col-md3">
            <div class="layui-card">
                <div class="layui-card-header">
                    剩余停车位
                    <i class="layui-icon layui-icon-list" style="font-size:25px;color:#1e9fff"></i>
                </div>
                <div class="layui-card-body layuiadmin-card-list">
                    <p class="layuiadmin-big-font"><%= availableParkingCount %></p>
                    <p>
                        <a href="<%=request.getContextPath()%>/parking_spot">
                            剩余停车位
                            <span class="layuiadmin-span-color"><i class="layui-inline layui-icon layui-icon-down"></i></span>
                        </a>
                    </p>
                </div>
            </div>
        </div>

        <!-- 第三个框：名下车辆 -->
        <div class="layui-col-sm6 layui-col-md3">
            <div class="layui-card">
                <div class="layui-card-header">
                    注册车辆
                    <i class="layui-icon layui-icon-reply-fill" style="color:#1e9fff"></i>
                </div>
                <div class="layui-card-body layuiadmin-card-list">
                    <p class="layuiadmin-big-font"><%= vehiclesCount %></p>
                    <p>
                        <a href="<%=request.getContextPath()%>/vehicles">
                            查看所有车辆
                            <span class="layuiadmin-span-color"><i class="layui-inline layui-icon layui-icon-down"></i></span>
                        </a>
                    </p>
                </div>
            </div>
        </div>
        <div class="layui-col-sm6 layui-col-md3">
            <div class="layui-card">
                <div class="layui-card-header">
                    总标签数
                    <i class="layui-icon layui-icon-note" style="color:#1e9fff"></i>
                </div>
                <div class="layui-card-body layuiadmin-card-list">

                    <p class="layuiadmin-big-font">${tagCount}</p>
                    <p>
                        <a lay-href="<%=request.getContextPath()%>/admin/article/tag">
                            查看所有
                            <span class="layuiadmin-span-color"><i
                                    class="layui-inline layui-icon layui-icon-down"></i></span>
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="layui-fluid">
    <div class="layui-row" style="display: flex; gap: 15px;">

        <!-- 右侧 iframe -->
        <iframe
                src="<%=request.getContextPath()%>/static/common/login.jsp"
                style="flex: 1; height: 500px; border: none; display:block ">
        </iframe>
        <!-- 左侧 iframe -->
        <iframe
                src="<%=request.getContextPath()%>/static/common/money.jsp"
                style="flex: 2.4; height: 400px; border: none; display: block;margin-left: 20px">
        </iframe>

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
    $("[id=reply]").on("click", function () {
        var id = $(this).attr('data-index')
        var str = "<%=request.getContextPath()%>/admin/comment/addreply/" + id;
        var c = $(this).parent().parent();
        layer.open({
            type: 2,
            title: '回复评论',
            content: str,
            maxmin: true,
            async: false,
            area: ['480px', '350px'],
            btn: ['确定', '取消'],
            yes: function (index, layero) {
                var comment = window["layui-layer-iframe" + index].callbackdata();
                console.log(comment);
                $.ajax({
                    url: '<%=request.getContextPath()%>/admin/comment/add',
                    data: comment,
                    cache: false,
                    dataType: "json",
                    success: function (data) {
                        if (data.state == 1) {
                            layer.alert("回复成功", {icon: 1});
                        } else
                            layer.msg("回复失败");
                    }
                });
                layer.close(index);
            }
        });
    });
</script>
</body>
</html>

