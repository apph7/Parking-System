<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>支付账单</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link href="//unpkg.com/layui@2.9.21/dist/css/layui.css" rel="stylesheet">
  <%@ include file="../common/message.jsp" %>
</head>
<body>
<div class="layui-fluid">
  <div class="layui-row layui-col-space15">
    <fieldset class="layui-elem-field layui-field-title">
      <legend>支付账单</legend>
    </fieldset>
    <div class="layui-tab layui-tab-card">
      <table class="layui-table">
        <colgroup>
          <col width="80">
          <col width="150">
          <col width="150">
          <col width="50">
          <col width="100">
          <col width="200">
        </colgroup>
        <thead>
        <tr>
          <th style="text-align:center;">支付单ID</th>
          <th style="text-align:center;">车牌号</th>
          <th style="text-align:center;">车位编号</th>
          <th style="text-align:center;">支付金额</th>
          <th style="text-align:center;">支付方式</th>
          <th style="text-align:center;">支付时间</th>

        </tr>
        </thead>
        <tbody>
        <%
          Properties properties = new Properties();
          InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
          properties.load(inputStream);

          String url = properties.getProperty("url");
          String dbUsername = properties.getProperty("user");
          String dbPassword = properties.getProperty("password");
          String dbDriver = properties.getProperty("driver");

          Connection conn = null;
          PreparedStatement pstmt = null;

          try {
            Class.forName(dbDriver);
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            // 从 session 获取当前用户 ID
            Integer userId = (Integer) session.getAttribute("userid");
            System.out.println(userId);
            if (userId == null) {
              request.getSession().setAttribute("message", "用户未登录，请重新登录！");
              request.getSession().setAttribute("messageType", "error");
              response.sendRedirect("login");
              return;
            }

            // 查询用户的支付记录
            String sql = "select * from user_payment where user_id = ?;";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
              int id = rs.getInt("id");
              String licensePlate = rs.getString("license_plate");
              String location = rs.getString("location");
              BigDecimal amount = rs.getBigDecimal("payment_amount");
              Timestamp paymentTime = rs.getTimestamp("payment_time");
              String paymentMethod = rs.getString("payment_method");

        %>
        <tr>
          <td align="center"><%= id %></td>
          <td align="center"><%= licensePlate %></td>
          <td align="center"><%= location %></td>
          <td align="center"><%= amount %></td>
          <td align="center"><%= paymentMethod %></td>
          <td align="center">
            <fmt:formatDate value="<%= paymentTime %>" pattern="yyyy-MM-dd HH:mm:ss" />
          </td>
        </tr>
        <%
            }
          } catch (Exception e) {
            e.printStackTrace();
          } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
          }
        %>
        </tbody>
      </table>
    </div>
  </div>
</div>
<script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>
</body>
</html>
