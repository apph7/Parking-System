<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>发布公告</title>
  <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
  <%@ include file="../common/message.jsp" %>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 800px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
  <fieldset style="margin-bottom: 20px; border: none;">
    <legend style="font-size: 20px; font-weight: bold; text-align: center;">发布公告</legend>
  </fieldset>

  <form method="post" action="edit_add_bulletin" class="layui-form" style="margin-top: 20px;">
    <!-- Title input -->
    <div class="layui-form-item">
      <div class="layui-input-block" style="width: 600px;">
        <input type="text" name="title" required lay-verify="required" placeholder="请输入公告标题" class="layui-input">
      </div>
    </div>
    <!-- End time input -->
    <div class="layui-form-item">
      <div class="layui-input-block" style="width: 300px;">
        <input type="text" name="endTime" class="layui-input" id="endTime" placeholder="请选择截至时间" required>
      </div>
    </div>
    <!-- Content input (CKEditor) -->
    <div class="layui-form-item">
      <div class="layui-input-block" style="width: 600px;">
        <textarea name="content" id="editor" rows="10" placeholder="请输入公告内容"></textarea>
      </div>
    </div>



    <!-- Submit button -->
    <div class="layui-form-item">
      <div style="text-align: center;">
        <button type="submit" class="layui-btn layui-btn-normal">发布</button>
      </div>
    </div>
  </form>
</div>

<script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>
<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
<script>
  // Initialize CKEditor
  CKEDITOR.replace('editor', {
    height: 300,
  });

  layui.use(['form', 'laydate'], function(){
    var form = layui.form;
    var laydate = layui.laydate;

    // Initialize date picker for end time
    laydate.render({
      elem: '#endTime',
      type: 'datetime',
    });

    form.verify({
      required: function(value){
        if(!value){
          return '此项不能为空';
        }
      }
    });
  });
</script>

<%
  // Form processing logic (insert announcement into the database)
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String endTime = request.getParameter("endTime");

    // Convert endTime to SQL TIMESTAMP format if necessary
    Timestamp timestamp = null;
    try {
      timestamp = Timestamp.valueOf(endTime);
    } catch (IllegalArgumentException e) {
      request.getSession().setAttribute("message", "无效的截至时间格式！");
      request.getSession().setAttribute("messageType", "success");
    }

    // Insert announcement into the database
    Connection conn = null;
    PreparedStatement stmt = null;
    try {
      Properties properties = new Properties();
      InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
      properties.load(inputStream);
      String url = properties.getProperty("url");
      String dbUsername = properties.getProperty("user");
      String dbPassword = properties.getProperty("password");
      String dbDriver = properties.getProperty("driver");
      Class.forName(dbDriver);
      conn = DriverManager.getConnection(url, dbUsername, dbPassword);

      // Insert announcement
      String sql = "INSERT INTO bulletin (title, content, end_time) VALUES (?, ?, ?)";
      stmt = conn.prepareStatement(sql);
      stmt.setString(1, title);
      stmt.setString(2, content);
      stmt.setTimestamp(3, timestamp);

      int result = stmt.executeUpdate();
      if (result > 0) {
        // 添加成功，存储提示信息到 Session
        request.getSession().setAttribute("message", "公告发布成功！");
        request.getSession().setAttribute("messageType", "success");

      } else {
        // 添加失败，存储提示信息到 Session
        request.getSession().setAttribute("message", "公告发布失败，请重试！");
        request.getSession().setAttribute("messageType", "error");
      }
      // 重定向到 user_info.jsp
      response.sendRedirect("bulletin");
    }catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  }
%>

</body>
</html>
