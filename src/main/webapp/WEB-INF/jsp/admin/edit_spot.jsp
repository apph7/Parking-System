<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>编辑停车位</title>
  <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
  <%@ include file="../common/message.jsp" %>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 500px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
  <fieldset style="margin-bottom: 20px; border: none;">
    <legend style="font-size: 20px; font-weight: bold; text-align: center;">编辑停车位</legend>
  </fieldset>
  <%
    String editId = request.getParameter("editId"); // 传入的编辑记录 ID
    String id = request.getParameter("id"); // 用于区分是否更新操作

    String location = request.getParameter("location");
    String status = request.getParameter("status");
    String price = request.getParameter("price");

    Properties properties = new Properties();
    InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
    properties.load(inputStream);
    String url = properties.getProperty("url");
    String dbUsername = properties.getProperty("user");
    String dbPassword = properties.getProperty("password");
    String dbDriver = properties.getProperty("driver");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
      Class.forName(dbDriver);
      conn = DriverManager.getConnection(url, dbUsername, dbPassword);

      if (id == null) {
        // 第一次加载页面，查询停车位信息
        String query = "SELECT location, status, price FROM parking_spot WHERE id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setLong(1, Long.parseLong(editId));
        rs = pstmt.executeQuery();

        if (rs.next()) {
          location = rs.getString("location");
          status = rs.getString("status");
          price = rs.getString("price");
        }
      } else {
        // 更新停车位信息
        String updateQuery = "UPDATE parking_spot SET location = ?, status = ?, price = ? WHERE id = ?";
        pstmt = conn.prepareStatement(updateQuery);
        pstmt.setString(1, location);
        pstmt.setString(2, status);
        pstmt.setBigDecimal(3, new BigDecimal(price));
        pstmt.setLong(4, Long.parseLong(id));

        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
          request.getSession().setAttribute("message", "修改成功！");
          request.getSession().setAttribute("messageType", "success");
        } else {
          request.getSession().setAttribute("message", "修改失败，请重试！");
          request.getSession().setAttribute("messageType", "error");
        }
        response.sendRedirect("parking_spot");
        return;
      }
    } catch (Exception e) {
      out.println("<script>alert('操作失败：" + e.getMessage() + "');</script>");
    } finally {
      if (rs != null) rs.close();
      if (pstmt != null) pstmt.close();
      if (conn != null) conn.close();
    }
  %>
  <form method="post" class="layui-form" style="margin-top: 20px;" action="edit_spot">
    <input type="hidden" name="id" value="<%= editId %>">
    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">车位位置</label>
      <div class="layui-input-inline" style="width: 300px;">
        <input type="text" name="location" value="<%= location %>" lay-verify="required" class="layui-input">
      </div>
    </div>
    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">状态</label>
      <div class="layui-input-inline" style="width: 300px;">
        <select name="status" class="layui-input">
          <option value="FREE" <%= "FREE".equals(status) ? "selected" : "" %>>空闲</option>
          <option value="OCCUPIED" <%= "OCCUPIED".equals(status) ? "selected" : "" %>>已占用</option>
        </select>
      </div>
    </div>
    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">价格</label>
      <div class="layui-input-inline" style="width: 300px;">
        <input type="text" name="price" value="<%= price %>" class="layui-input">
      </div>
    </div>
    <div class="layui-form-item">
      <div style="text-align: center;">
        <button type="submit" class="layui-btn">提交修改</button>
        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
      </div>
    </div>
  </form>
</div>
<script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>
<script>
  layui.use(['laydate'], function () {
    var laydate = layui.laydate;

    // If you need to add date picker functionality, you can add them here
  });
</script>
</body>
</html>
