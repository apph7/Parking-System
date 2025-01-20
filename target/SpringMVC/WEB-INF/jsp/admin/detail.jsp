<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告详情</title>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7fa;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 30px auto;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .title {
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }
        .content {
            font-size: 16px;
            color: #555;
            line-height: 1.8;
        }
        .footer {
            margin-top: 30px;
            text-align: right;
            font-size: 14px;
            color: #888;
        }
        .status {
            padding: 6px 16px;
            border-radius: 10px;
            font-weight: bold;
        }
        .active {
            background-color: #58d68d;
            color: white;
        }
        .expired {
            background-color: #f1948a;
            color: white;
        }
    </style>
</head>
<body>

<%
    // Load JDBC configuration
    Properties properties = new Properties();
    InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
    properties.load(inputStream);

    String url = properties.getProperty("url");
    String dbUsername = properties.getProperty("user");
    String dbPassword = properties.getProperty("password");
    String dbDriver = properties.getProperty("driver");

    String bulletinId = "1";
    bulletinId = request.getParameter("id");
    Map<String, String> bulletin = new HashMap<>();

    try {
        Class.forName(dbDriver);
        try (Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword)) {
            String query = "SELECT * FROM bulletin WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, Integer.parseInt(bulletinId));
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        bulletin.put("id", rs.getString("id"));
                        bulletin.put("title", rs.getString("title"));
                        bulletin.put("content", rs.getString("content"));
                        bulletin.put("publish_time", rs.getString("publish_time"));
                        bulletin.put("author", rs.getString("author"));
                        bulletin.put("end_time", rs.getString("end_time"));

                        // Determine status based on end_time
                        Date currentDate = new Date();
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        Date endDate = sdf.parse(rs.getString("end_time"));
                        String status = (endDate != null && currentDate.before(endDate)) ? "active" : "expired";
                        bulletin.put("status", status);
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<div class="container">
    <div class="title"><%= bulletin.get("title") %></div>

    <div class="content">
        <%= bulletin.get("content") %>
    </div>

    <div class="footer">
        <span class="status <%= "active".equals(bulletin.get("status")) ? "active" : "expired" %>">
            <%= "active".equals(bulletin.get("status")) ? "活跃" : "过期" %>
        </span>
        <br>
        <small>发布人: <%= bulletin.get("author") %> | 发布时间: <%= bulletin.get("publish_time") %> | 截止时间: <%= bulletin.get("end_time") %></small>
    </div>
</div>

<script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>
</body>
</html>
