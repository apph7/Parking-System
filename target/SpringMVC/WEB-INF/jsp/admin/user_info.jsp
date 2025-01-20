<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>停车记录</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery.js"></script>
    <script src="<%=request.getContextPath()%>/static/js/md5.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <%@ include file="../common/message.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/style/admin.css" media="all">
    <link href="//unpkg.com/layui@2.9.21/dist/css/layui.css" rel="stylesheet">
</head>

<body>

<%
    // 加载 jdbc.properties 配置文件
    Properties properties = new Properties();
    InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
    properties.load(inputStream);

    String url = properties.getProperty("url");
    String dbUsername = properties.getProperty("user");
    String dbPassword = properties.getProperty("password");
    String dbDriver = properties.getProperty("driver");

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    ResultSet rsSpot = null;

    // 查询停车记录
    try {
        // 加载 MySQL 驱动
        Class.forName(dbDriver);
        // 获取数据库连接
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // 创建 SQL 查询停车记录
        String sql = "SELECT id, username, email, telephone, firm, money, create_time FROM guest";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        // 处理删除操作
        String deleteId = request.getParameter("deleteId");
        if (deleteId != null) {
            try {
                String deleteSql = "DELETE FROM guest WHERE id = ?";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                deleteStmt.setLong(1, Long.parseLong(deleteId));
                int rowsAffected = deleteStmt.executeUpdate();
                if (rowsAffected > 0) {
                    // 添加成功，存储提示信息到 Session
                    request.getSession().setAttribute("message", "删除成功！");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    // 添加失败，存储提示信息到 Session
                    request.getSession().setAttribute("message", "删除失败！");
                    request.getSession().setAttribute("messageType", "error");
                }
                // 重定向到 user_info.jsp
                response.sendRedirect("user_info");
            } catch (SQLException e) {
                e.printStackTrace();
                // 添加失败，存储提示信息到 Session
                request.getSession().setAttribute("message", "异常！");
                request.getSession().setAttribute("messageType", "error");
            }
        }

%>

<!-- 列表 -->
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>
                用户列表
                <a href="edit_add_user">
                <button class="layui-btn">添加用户</button>
                </a>
            </legend>
        </fieldset>
        <div class="layui-tab layui-tab-card">
            <table class="layui-table">
                <colgroup>
                    <col width="40"> <!-- 调整为更合适的宽度 -->
                    <col width="100">
                    <col width="100"> <!-- 调整停车位编号列宽度 -->
                    <col width="100"> <!-- 入场时间宽度 -->
                    <col width="100"> <!-- 离场时间宽度 -->
                    <col width="40"> <!-- 停车费列宽度 -->
                    <col width="80"> <!-- 状态列宽度 -->
                    <col width="150"> <!-- 创建时间宽度 -->

                </colgroup>
                <thead>
                <tr>
                    <th style="text-align:center;">ID</th>
                    <th style="text-align:center;">用户名</th>
                    <th style="text-align:center;">邮箱</th>
                    <th style="text-align:center;">电话</th>
                    <th style="text-align:center;">公司</th>
                    <th style="text-align:center;">余额</th>
                    <th style="text-align:center;">创建时间</th>
                    <th style="text-align:center;">操作</th>
                </tr>
                </thead>
                <tbody>
                <%
                    // 遍历查询结果并显示
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String username = rs.getString("username");
                        String email = rs.getString("email");
                        String telephone = rs.getString("telephone") != null ? rs.getString("telephone") : "N/A";
                        String firm = rs.getString("firm") != null ? rs.getString("firm") : "N/A";
                        double money = rs.getDouble("money");
                        Timestamp createTime = rs.getTimestamp("create_time");
                %>
                <tr>
                    <td align="center"><%= id %></td>
                    <td align="center"><%= username %></td>
                    <td align="center"><%= email %></td>
                    <td align="center"><%= telephone %></td>
                    <td align="center"><%= firm %></td>
                    <td align="center"><%= money %></td>
                    <td align="center">
                        <fmt:formatDate value="<%= createTime %>" pattern="yyyy-MM-dd HH:mm:ss" />
                    </td>
                    <td align="center">
                        <!-- 删除按钮 -->
                        <form action="user_info" method="post" style="display:inline;">
                            <input type="hidden" name="deleteId" value="<%= id %>">
                            <button type="submit" class="layui-btn layui-btn-danger layui-btn-mini">删除</button>
                        </form>
                        <!-- 修改按钮 -->
                        <form action="edit_user" method="post" style="display:inline;">
                            <input type="hidden" name="editId" value="<%= id %>">
                            <button type="submit" class="layui-btn layui-btn-normal layui-btn-mini">修改</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (rsSpot != null) rsSpot.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<script src="<%=request.getContextPath()%>/static/editor/js/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/static/layuiadmin/layui/layui.js"></script>

</body>
</html>
