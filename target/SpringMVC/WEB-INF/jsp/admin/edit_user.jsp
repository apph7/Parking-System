<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑用户信息</title>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <%@ include file="../common/message.jsp" %>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 500px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
    <fieldset style="margin-bottom: 20px; border: none;">
        <legend style="font-size: 20px; font-weight: bold; text-align: center;">编辑用户信息</legend>
    </fieldset>
    <%
        String editId = request.getParameter("editId"); // 传入的编辑记录 ID
        String Id = request.getParameter("Id"); // 传入的编辑记录 ID
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String firm = request.getParameter("firm");
        String money = request.getParameter("money");

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
          if(Id == null) {
              // 查询用户信息
              String query = "SELECT username, password, email, telephone, firm, money FROM guest WHERE id = ?";
              pstmt = conn.prepareStatement(query);
              pstmt.setInt(1, Integer.parseInt(editId));
              rs = pstmt.executeQuery();

              if (rs.next()) {
                  username = rs.getString("username");
                  password = rs.getString("password");
                  email = rs.getString("email");
                  telephone = rs.getString("telephone");
                  firm = rs.getString("firm");
                  money = rs.getString("money");
              }
          }else {

                  String updateQuery = "UPDATE guest SET username = ?, password = ?, email = ?, telephone = ?, firm = ?, money = ? WHERE id = ?";
                  pstmt = conn.prepareStatement(updateQuery);
                  pstmt.setString(1, username);
                  pstmt.setString(2, password);
                  pstmt.setString(3, email);
                  pstmt.setString(4, telephone);
                  pstmt.setString(5, firm);
                  pstmt.setDouble(6, Double.parseDouble(money));
                  pstmt.setInt(7, Integer.parseInt(Id));

                  int rowsUpdated = pstmt.executeUpdate();
                  if (rowsUpdated > 0) {
                      request.getSession().setAttribute("message", "用户信息修改成功！");
                      request.getSession().setAttribute("messageType", "success");
                  } else {
                      request.getSession().setAttribute("message", "用户信息修改失败，请重试！");
                      request.getSession().setAttribute("messageType", "error");
                  }
                  response.sendRedirect("user_info");

          }
        } catch (Exception e) {
            out.println("<script>alert('操作失败：" + e.getMessage() + "');</script>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    <form method="post" class="layui-form" style="margin-top: 20px;" action="edit_user">
        <input type="hidden" name="Id" value="<%= editId %>">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">用户名</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="username" value="<%= username %>" lay-verify="required" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">密码</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="password" value="<%= password %>" lay-verify="required" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">邮箱</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="email" value="<%= email %>" lay-verify="required|email" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">电话</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="telephone" value="<%= telephone %>" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">公司</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="firm" value="<%= firm %>" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">余额</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="money" value="<%= money %>" class="layui-input">
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
</body>
</html>
