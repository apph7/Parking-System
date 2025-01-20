<%@ page import="java.sql.*" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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

      // 获取用户ID
      Integer userId = (Integer) session.getAttribute("userid");
      if (userId == null) {
        response.sendRedirect("User/index"); // 重定向到登录页面
        return;
      }

      // 查询剩余停车位数
      String availableParkingSql = "SELECT COUNT(*) FROM parking_spot WHERE status = 'FREE'";
      PreparedStatement availableParkingStmt = conn.prepareStatement(availableParkingSql);
      ResultSet availableParkingRs = availableParkingStmt.executeQuery();
      int availableParkingCount = 0;
      if (availableParkingRs.next()) {
        availableParkingCount = availableParkingRs.getInt(1);
      }

      // 查询名下车辆数
      String vehiclesSql = "SELECT COUNT(*) FROM vehicles WHERE user_id = ?";
      PreparedStatement vehiclesStmt = conn.prepareStatement(vehiclesSql);
      vehiclesStmt.setInt(1, userId);
      ResultSet vehiclesRs = vehiclesStmt.executeQuery();
      int vehiclesCount = 0;
      if (vehiclesRs.next()) {
        vehiclesCount = vehiclesRs.getInt(1);
      }

      // 查询余额
      String moneySql = "SELECT money FROM guest WHERE id = ?";
      PreparedStatement moneyStmt = conn.prepareStatement(moneySql);
      moneyStmt.setInt(1, userId);
      ResultSet moneyRs = moneyStmt.executeQuery();
      double money = 0.0;
      if (moneyRs.next()) {
        money = moneyRs.getDouble("money");
      }

      // 查询活跃公告
      String bulletinSql = "SELECT title, publish_time,status FROM v_bulletin ORDER BY `end_time` DESC LIMIT 5";
      PreparedStatement bulletinStmt = conn.prepareStatement(bulletinSql);
      ResultSet bulletinRs = bulletinStmt.executeQuery();


    // 确保查询语句正确
      String parkingRecordSql = "SELECT * FROM vehicle_parking WHERE user_id = ? ORDER BY entry_time DESC LIMIT 5";
      PreparedStatement parkingRecordStmt = conn.prepareStatement(parkingRecordSql);
      parkingRecordStmt.setInt(1, userId); // 设置用户ID

      // 执行查询并获取结果集
      ResultSet parkingRecordRs = parkingRecordStmt.executeQuery();

%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>用户主页</title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/layui/css/layui.css" media="all">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/style/admin.css" media="all">
  <%@ include file="../common/message.jsp" %>
  <style>
    body {
      background-color: #f7f7f7; /* 浅灰色背景 */
      font-family: Arial, sans-serif;
    }

    .layui-card {
      background-color: #ffffff;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .layui-card-header {
      color: #4d9ce1; /* 柔和的蓝色 */
      font-size: 16px;
    }

    .layui-icon {
      color: #4d9ce1; /* 柔和的蓝色 */
    }

    .layui-card a {
      color: #4d9ce1; /* 柔和的蓝色 */
    }

    .layui-card a:hover {
      color: #1e7fc7; /* 更深的蓝色 */
    }

    .layui-table {
      background-color: #f9f9f9;
      border-collapse: collapse;
    }

    .layui-table th, .layui-table td {
      padding: 10px;
      text-align: center;
      border: 1px solid #ddd;
    }

    .layui-table th {
      background-color: #f0f0f0;
      color: #666666;
    }

    .layui-card-body p {
      color: #666666; /* 浅灰色文字 */
    }

    .layuiadmin-big-font {
      font-size: 24px;
      color: #333333;
    }

  </style>
</head>

<body>

<div class="layui-fluid">
  <div class="layui-row layui-col-space15">
    <!-- 第一个框：新增访问量 -->
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
            <span class="layuiadmin-span-color">755<i class="layui-inline layui-icon layui-icon-flag"></i></span>
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
            <a href="<%=request.getContextPath()%>/userspot">
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
          名下车辆
          <i class="layui-icon layui-icon-reply-fill" style="color:#1e9fff"></i>
        </div>
        <div class="layui-card-body layuiadmin-card-list">
          <p class="layuiadmin-big-font"><%= vehiclesCount %></p>
          <p>
            <a href="<%=request.getContextPath()%>/uservehicles">
              查看名下所有车辆
              <span class="layuiadmin-span-color"><i class="layui-inline layui-icon layui-icon-down"></i></span>
            </a>
          </p>
        </div>
      </div>
    </div>

    <!-- 第四个框：余额 -->
    <div class="layui-col-sm6 layui-col-md3">
      <div class="layui-card">
        <div class="layui-card-header">
          余额
          <i class="layui-icon layui-icon-note" style="color:#1e9fff"></i>
        </div>
        <div class="layui-card-body layuiadmin-card-list">
          <p class="layuiadmin-big-font"><%= money %></p>
          <p>
            <a href="<%=request.getContextPath()%>/account">
              账户余额
              <span class="layuiadmin-span-color"><i class="layui-inline layui-icon layui-icon-down"></i></span>
            </a>
          </p>
        </div>
      </div>
    </div>

  </div>
</div>

<div class="layui-fluid">
  <div class="layui-row layui-col-space15">

    <!-- 系统公告展示 -->
    <div class="layui-col-sm12 layui-col-md6">
      <div class="layui-card">
        <div class="layui-card-header">
          系统公告
        </div>
        <div class="layui-card-body">
          <table class="layui-table layuiadmin-page-table">
            <colgroup>
              <col width="300">
              <col width="150">
              <col width="100">
              <col width="150">
            </colgroup>
            <thead>
            <tr>
              <th>标题</th>
              <th>发布时间</th>
              <th>状态</th>
            </tr>
            </thead>
            <tbody>
            <%
              while (bulletinRs.next()) {
                String title = bulletinRs.getString("title");
                Timestamp publishTime = bulletinRs.getTimestamp("publish_time");
                String status = bulletinRs.getString("status");
                String statusClass = "status-pending"; // Default status
                if ("ACTIVE".equals(status)) {
                  statusClass = "status-active";
                } else if ("INACTIVE".equals(status)) {
                  statusClass = "status-inactive";
                }
            %>
            <tr>
              <td>
                <a  target="_blank"><%= title %></a>
              </td>
              <td>
                <%= publishTime %>
              </td>
              <td>
                <span class="<%= statusClass %>"><%= status %></span>
              </td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- 最近停车记录展示 -->
    <div class="layui-col-sm12 layui-col-md6">
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

<script src="<%=request.getContextPath()%>/static/editor/js/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/static/layuiadmin/layui/layui.js"></script>

</body>
</html>

<%
  // 关闭数据库资源
  if (availableParkingRs != null) try { availableParkingRs.close(); } catch (SQLException e) { e.printStackTrace(); }
  if (availableParkingStmt != null) try { availableParkingStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
  if (vehiclesRs != null) try { vehiclesRs.close(); } catch (SQLException e) { e.printStackTrace(); }
  if (vehiclesStmt != null) try { vehiclesStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
  if (moneyRs != null) try { moneyRs.close(); } catch (SQLException e) { e.printStackTrace(); }
  if (moneyStmt != null) try { moneyStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
  if (bulletinRs != null) try { bulletinRs.close(); } catch (SQLException e) { e.printStackTrace(); }
  if (bulletinStmt != null) try { bulletinStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
  if (parkingRecordRs != null) try { parkingRecordRs.close(); } catch (SQLException e) { e.printStackTrace(); }
  if (parkingRecordStmt != null) try { parkingRecordStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
  if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
%>
