<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>我的账户</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/layuiadmin/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/layuiadmin/style/admin.css" media="all">
    <style>
        .user-profile-section {
            display: flex;
            justify-content: space-between;
        }
        .user-profile-left {
            flex: 1;
            padding-right: 30px;
        }
        .user-profile-right {
            width: 250px;
            padding-left: 30px;
            background-color: #f7f7f7;
            border-radius: 8px;
            padding: 20px;
        }
        .layui-table th, .layui-table td {
            text-align: center;
        }
    </style>
</head>
<body>

<%
    // Get user ID from session
    Integer userId = (Integer) session.getAttribute("userid");

    // Load database properties
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

    // Query for user data
    try {
        // Load MySQL driver
        Class.forName(dbDriver);
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // Query user data from the guest table
        String userQuery = "SELECT id, username, email, telephone, firm, money, create_time FROM guest WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(userQuery);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            String username = rs.getString("username");
            String email = rs.getString("email");
            String telephone = rs.getString("telephone");
            String firm = rs.getString("firm");
            double money = rs.getDouble("money");
            Timestamp createTime = rs.getTimestamp("create_time");
        }
%>

<!-- User Profile Section -->
<div class="layui-container">
    <fieldset class="layui-elem-field layui-field-title">
        <legend>用户资料</legend>
    </fieldset>

    <!-- User Profile and Right Section -->
    <div class="user-profile-section">
        <!-- Left side: User Profile Details -->
        <div class="user-profile-left">
            <table class="layui-table">
                <tr>
                    <th>用户名</th>
                    <td><%= rs.getString("username") %></td>
                </tr>
                <tr>
                    <th>邮箱</th>
                    <td><%= rs.getString("email") %></td>
                </tr>
                <tr>
                    <th>电话</th>
                    <td><%= rs.getString("telephone") != null ? rs.getString("telephone") : "未设置" %></td>
                </tr>
                <tr>
                    <th>公司</th>
                    <td><%= rs.getString("firm") != null ? rs.getString("firm") : "未设置" %></td>
                </tr>
                <tr>
                    <th>账户余额</th>
                    <td><%= rs.getDouble("money") %></td>
                </tr>
                <tr>
                    <th>注册时间</th>
                    <td><fmt:formatDate value="${createTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
            </table>
        </div>

        <!-- Right side: Additional Information or Options -->
        <div class="user-profile-right">
            <h3>快速操作</h3>
            <ul class="layui-nav layui-nav-tree">
                <li class="layui-nav-item">
                    <a href="change_password.jsp">修改密码</a>
                </li>
                <li class="layui-nav-item">
                    <a href="edit_user_profile.jsp">修改个人资料</a>
                </li>
                <li class="layui-nav-item">
                    <a href="parking_history.jsp">停车记录</a>
                </li>
                <li class="layui-nav-item">
                    <a href="transaction_history.jsp">交易记录</a>
                </li>
            </ul>
        </div>
    </div>

    <!-- Change Password Section -->
    <fieldset class="layui-elem-field">
        <legend>修改密码</legend>
    </fieldset>

    <form action="update_password.jsp" method="post">
        <div class="layui-row">
            <div class="layui-col-xs12">
                <div class="layui-form-item">
                    <label class="layui-form-label">新密码</label>
                    <div class="layui-input-block">
                        <input type="password" name="newPassword" required class="layui-input" placeholder="输入新密码">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">确认密码</label>
                    <div class="layui-input-block">
                        <input type="password" name="confirmPassword" required class="layui-input" placeholder="确认新密码">
                    </div>
                </div>
                <button type="submit" class="layui-btn layui-btn-normal">更新密码</button>
            </div>
        </div>
    </form>

</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<script src="<%= request.getContextPath() %>/static/layuiadmin/layui/layui.js"></script>
<script>
    layui.use('form', function() {
        var form = layui.form;
    });
</script>
</body>
</html>
