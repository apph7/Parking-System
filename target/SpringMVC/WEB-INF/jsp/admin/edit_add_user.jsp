<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>添加用户</title>
  <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
  <%@ include file="../common/message.jsp" %>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 500px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
  <fieldset style="margin-bottom: 20px; border: none;">
    <legend style="font-size: 20px; font-weight: bold; text-align: center;">添加用户</legend>
  </fieldset>
  <%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String telephone = request.getParameter("telephone");
            String firm = request.getParameter("firm");

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

              // Check if username or email is empty
              if (username == null || username.isEmpty() || email == null || email.isEmpty()) {
                request.getSession().setAttribute("message", "用户名和邮箱不能为空！");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("edit_add_user");
                return;
              }

              // Check if the username or email already exists
              String checkQuery = "SELECT * FROM guest WHERE username = ? OR email = ?";
              pstmt = conn.prepareStatement(checkQuery);
              pstmt.setString(1, username);
              pstmt.setString(2, email);
              rs = pstmt.executeQuery();

              if (rs.next()) {
                // If a record is found, display error message
                request.getSession().setAttribute("message", "用户名或邮箱已存在！");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("edit_add_user");
              } else {
                // Insert new user if no duplicate is found
                String insertQuery = "INSERT INTO guest (username, password, email, telephone, firm) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertQuery);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                pstmt.setString(3, email);
                pstmt.setString(4, telephone);
                pstmt.setString(5, firm);

                int rows = pstmt.executeUpdate();

                if (rows > 0) {
                  // Adding user was successful, set success message
                  request.getSession().setAttribute("message", "用户添加成功！");
                  request.getSession().setAttribute("messageType", "success");
                } else {
                  // Adding user failed, set error message
                  request.getSession().setAttribute("message", "添加失败，请重试");
                  request.getSession().setAttribute("messageType", "error");
                }
                // Redirect to the user list page
                response.sendRedirect("user_info");
              }
            } catch (Exception e) {
              request.getSession().setAttribute("message", "添加失败，请重试！");
              request.getSession().setAttribute("messageType", "error");
              response.sendRedirect("guest_list.jsp");
            } finally {
              if (rs != null) rs.close();
              if (pstmt != null) pstmt.close();
              if (conn != null) conn.close();
            }
    }
  %>
  <form action="edit_add_user" method="post" class="layui-form" style="margin-top: 20px;">
    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">用户名</label>
      <div class="layui-input-inline" style="width: 300px;">
        <input type="text" name="username"  lay-verify="required" class="layui-input">
      </div>
    </div>
    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">密码</label>
      <div class="layui-input-inline" style="width: 300px;">
        <input type="password" name="password"  lay-verify="required" class="layui-input">
      </div>
    </div>
    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">邮箱</label>
      <div class="layui-input-inline" style="width: 300px;">
        <input type="email" name="email"  lay-verify="required|email" class="layui-input">
      </div>
    </div>
    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">电话</label>
      <div class="layui-input-inline" style="width: 300px;">
        <input type="text" name="telephone" class="layui-input">
      </div>
    </div>
    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">公司</label>
      <div class="layui-input-inline" style="width: 300px;">
        <input type="text" name="firm" class="layui-input">
      </div>
    </div>
    <div class="layui-form-item">
      <div style="text-align: center;">
        <button type="submit" class="layui-btn">提交添加</button>
        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
      </div>
    </div>
  </form>
</div>

<script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>
<script>
  layui.use('form', function(){
    var form = layui.form;
    form.verify({
      required: function(value){
        if(!value){
          return '此项不能为空';
        }
      },
      email: function(value){
        if(value && !/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/.test(value)){
          return '请输入有效的邮箱地址';
        }
      }
    });
  });
</script>
</body>
</html>
