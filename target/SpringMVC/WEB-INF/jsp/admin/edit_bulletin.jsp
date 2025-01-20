<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑公告</title>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <%@ include file="../common/message.jsp" %>

</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; background-color: #f5f5f5;">
<div style="width: 90%; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
    <fieldset style="margin-bottom: 20px; border: none;">
        <legend style="font-size: 20px; font-weight: bold; text-align: center;">编辑公告</legend>
    </fieldset>

    <%
        String id = request.getParameter("id"); // 传入的编辑记录 ID
        String editId = request.getParameter("editId"); // 传入的编辑记录 ID
        String title = "";
        String content = "";
        String endTime = "";

        // 判断请求方式，处理表单提交
        if (id != null) {
            // 获取提交的表单数据
            title = request.getParameter("title");
            content = request.getParameter("content");
            endTime = request.getParameter("endTime");


                // 更新公告信息到数据库
                Connection conn = null;
                PreparedStatement pstmt = null;
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

                    // 更新公告信息
                    String updateQuery = "UPDATE bulletin SET title = ?, content = ?, end_time = ? WHERE id = ?";
                    pstmt = conn.prepareStatement(updateQuery);
                    pstmt.setString(1, title);
                    pstmt.setString(2, content);
                    pstmt.setTimestamp(3, Timestamp.valueOf(endTime));
                    pstmt.setLong(4, Long.parseLong(id));

                    int rowsUpdated = pstmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        request.getSession().setAttribute("message", "公告修改成功！");
                        request.getSession().setAttribute("messageType", "success");
                        response.sendRedirect("bulletin");
                    } else {
                        request.getSession().setAttribute("message", "修改失败，请重试！");
                        request.getSession().setAttribute("messageType", "error");
                        response.sendRedirect("edit_bulletin");
                    }

                } catch (Exception e) {
                    out.println("<script>alert('操作失败：" + e.getMessage() + "');</script>");
                } finally {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }

        } else {
            // 编辑模式：从数据库加载公告内容
            if (editId != null && !editId.isEmpty()) {
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

                    // 查询公告信息
                    String query = "SELECT title, content, end_time FROM bulletin WHERE id = ?";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setLong(1, Long.parseLong(editId));
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        title = rs.getString("title");
                        content = rs.getString("content");
                        endTime = rs.getString("end_time");
                    }

                } catch (Exception e) {
                    out.println("<script>alert('操作失败：" + e.getMessage() + "');</script>");
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            }
        }
    %>

    <form method="post" action="edit_bulletin" class="layui-form" style="margin-top: 10px; margin-left: 100px">
        <input type="hidden" name="id" value="<%= editId != null ? editId : "" %>">

        <!-- 公告标题 -->
        <div class="layui-form-item" style="width: 80%;">
            <div class="layui-input-block">
                <input type="text" name="title" value="<%= title != null ? title : "" %>" required lay-verify="required" class="layui-input">
            </div>
        </div>

        <!-- 截止时间 -->
        <div class="layui-form-item" style="width: 40%;">
            <div class="layui-input-block">
                <input type="text" id="endTime" name="endTime" value="<%= endTime != null ? endTime : "" %>" class="layui-input" placeholder="请选择截止时间">
            </div>
        </div>

        <!-- 公告内容 -->
        <div class="layui-form-item" style="width: 80%;">
            <div class="layui-input-block">
                <textarea name="content" id="editor" rows="10" required lay-verify="required"><%= content != null ? content : "" %></textarea>
            </div>
        </div>

        <!-- 提交按钮 -->
        <div class="layui-form-item" style="text-align: center;">
            <button type="submit" class="layui-btn layui-btn-normal">提交修改</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>
    </form>
</div>

<script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>
<script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
<script>
    // 初始化富文本编辑器
    CKEDITOR.replace('editor', {
        height: 300,
        filebrowserUploadUrl: 'uploadImage', // 配置图片上传接口
        filebrowserUploadMethod: 'form'
    });

    layui.use(['laydate'], function () {
        var laydate = layui.laydate;

        laydate.render({
            elem: '#endTime',
            type: 'datetime'
        });
    });
</script>
</body>
</html>
