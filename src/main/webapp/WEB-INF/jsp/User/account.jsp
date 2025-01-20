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
    <%@ include file="../common/message.jsp" %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/layuiadmin/style/admin.css" media="all">
    <style>
        /* General Layout Enhancements */
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
            padding-top: 30px;
        }

        .layui-container {
            margin-top: 20px;
        }

        /* User Data Section */
        .user-data-box {
            display: flex;
            align-items: center;
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .user-data-box img {
            border-radius: 50%;
            width: 80px;
            height: 80px;
            margin-right: 20px;
        }

        .user-data-box .user-info {
            flex-grow: 1;
        }

        .user-data-box .user-info p {
            margin: 5px 0;
        }

        .user-data-box .edit-button {
            color: #007BFF;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }

        /* Edit User Form */
        .edit-user-form {
            display: none;
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

        .layui-form-item {
            margin-bottom: 15px;
        }

        /* Parking Records Table */
        .parking-table {
            margin-top: 20px;
        }

        .layui-card-body {
            padding: 0;
        }

        .background-footer {
            background: url('https://www.example.com/path-to-your-image.jpg') no-repeat center center;
            background-size: cover;
            padding: 50px 0;
            text-align: center;
            color: white;
            font-size: 18px;
            margin-top: 50px;
        }

        /* Calendar Container */
        .calendar-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-top: 30px;
        }

        .calendar-container h3 {
            margin-bottom: 15px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
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

        //
        // 确保查询语句正确
        String parkingRecordSql = "SELECT * FROM vehicle_parking WHERE user_id = ? ORDER BY entry_time DESC LIMIT 5";
        PreparedStatement parkingRecordStmt = conn.prepareStatement(parkingRecordSql);
        parkingRecordStmt.setInt(1, userId); // 设置用户ID

        // 执行查询并获取结果集
        ResultSet parkingRecordRs = parkingRecordStmt.executeQuery();

        if (rs.next()) {
            String username = rs.getString("username");
            String email = rs.getString("email");
            String telephone = rs.getString("telephone");
            String firm = rs.getString("firm");
            double money = rs.getDouble("money");
            Timestamp createTime = rs.getTimestamp("create_time");
        }
%>

<!-- User Data Section (Top Section) -->
<div class="layui-container">
    <div class="user-data-box">
        <img src="<%=request.getContextPath()%>/static/OIP.jpg" alt="User Avatar">
        <div class="user-info">
            <p><strong>用户名：</strong><%= rs.getString("username") %></p>
            <p><strong>电话：</strong><%= rs.getString("telephone") != null ? rs.getString("telephone") : "未设置" %></p>
            <p><strong>邮箱：</strong><%= rs.getString("email") %></p>
        </div>
        <a href="recharge">
            <span class="edit-button" onclick="toggleEditForm()">充值</span>
        </a>

    </div>

    <!-- Edit User Form (Initially Hidden) -->
    <div class="edit-user-form" id="editUserForm">
        <form action="update_user.jsp" method="post">
            <div class="layui-form-item">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-block">
                    <input type="text" name="username" value="<%= rs.getString("username") %>" required class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">电话</label>
                <div class="layui-input-block">
                    <input type="text" name="telephone" value="<%= rs.getString("telephone") != null ? rs.getString("telephone") : "" %>" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">邮箱</label>
                <div class="layui-input-block">
                    <input type="email" name="email" value="<%= rs.getString("email") %>" required class="layui-input">
                </div>
            </div>
            <button type="submit" class="layui-btn layui-btn-normal">保存修改</button>
        </form>
    </div>
</div>

<!-- Parking Records Section -->
<div class="layui-container parking-table">
    <div class="layui-row">
        <div class="layui-col-md12">
            <div class="layui-card">
                <div class="layui-card-header">
                    最近停车记录
                </div>
                <div class="layui-card-body">
                    <table class="layui-table layuiadmin-page-table">
                        <colgroup>
                            <col width="150">
                            <col width="150">
                            <col width="150">
                            <col width="50">
                            <col width="150">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>车牌</th>
                            <th>入场时间</th>
                            <th>出场时间</th>
                            <th>费用</th>
                            <th>状态</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%
                            while (parkingRecordRs.next()) {
                                String licensePlate = parkingRecordRs.getString("license_plate");
                                Timestamp entryTime = parkingRecordRs.getTimestamp("entry_time");
                                Timestamp exitTime = parkingRecordRs.getTimestamp("exit_time");
                                double fee = parkingRecordRs.getDouble("fee");
                                String status = parkingRecordRs.getString("parking_status");
                                String statusClass = "status-pending";
                                if ("ACTIVE".equals(status)) {
                                    statusClass = "status-active";
                                } else if ("INACTIVE".equals(status)) {
                                    statusClass = "status-inactive";
                                }
                        %>
                        <tr>
                            <td><%= licensePlate %></td>
                            <td><%= entryTime %></td>
                            <td><%= (exitTime != null ? exitTime : "未出场") %></td>
                            <td>￥<%= fee %></td>
                            <td><span class="<%= statusClass %>"><%= status %></span></td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>




<script src="<%= request.getContextPath() %>/static/layuiadmin/layui/layui.js"></script>
<script src="<%= request.getContextPath() %>/static/layuiadmin/layui/laydate/laydate.js"></script>

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

</body>
</html>