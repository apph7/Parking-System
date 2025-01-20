<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.Properties, java.io.InputStream, java.io.IOException" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>添加车位信息</title>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <%@ include file="../common/message.jsp" %>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 500px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
    <fieldset style="margin-bottom: 20px; border: none;">
        <legend style="font-size: 20px; font-weight: bold; text-align: center;">添加车位信息</legend>
    </fieldset>

    <form method="post" class="layui-form" style="margin-top: 20px;" action="edit_add_spot">

        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">车位位置</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="location" lay-verify="required" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">车位状态</label>
            <div class="layui-input-inline" style="width: 300px;">
                <select name="status" class="layui-input">
                    <option value="FREE">空闲</option>
                    <option value="OCCUPIED">已占用</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">价格</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="price" lay-verify="required|number" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <div style="text-align: center;">
                <button type="submit" class="layui-btn">添加车位</button>
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
            number: function(value){
                if(!/^\d+(\.\d+)?$/.test(value)){
                    return '请输入有效的数字';
                }
            }
        });
    });
</script>
</body>
</html>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String location = request.getParameter("location");
        String status = request.getParameter("status");
        String price = request.getParameter("price");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        String queryCheck = "SELECT COUNT(*) FROM parking_spot WHERE location = ?";
        String queryInsert = "INSERT INTO parking_spot (location, status, price) VALUES (?, ?, ?)";

        // Load jdbc.properties configuration file
        Properties properties = new Properties();
        InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
        properties.load(inputStream);

        String url = properties.getProperty("url");
        String dbUsername = properties.getProperty("user");
        String dbPassword = properties.getProperty("password");
        String dbDriver = properties.getProperty("driver");

        try {
            Class.forName(dbDriver);
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            // Check for duplicate location
            pstmt = conn.prepareStatement(queryCheck);
            pstmt.setString(1, location);
            resultSet = pstmt.executeQuery();

            if (resultSet.next() && resultSet.getInt(1) > 0) {
                // Location already exists
                request.getSession().setAttribute("message", "该位置已存在，无法添加重复车位！");
                request.getSession().setAttribute("messageType", "error");
            } else {
                // Insert new parking spot
                pstmt.close(); // Close previous PreparedStatement
                pstmt = conn.prepareStatement(queryInsert);
                pstmt.setString(1, location);
                pstmt.setString(2, status);
                pstmt.setBigDecimal(3, new BigDecimal(price));

                int rowsInserted = pstmt.executeUpdate();
                if (rowsInserted > 0) {
                    request.getSession().setAttribute("message", "车位添加成功！");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    request.getSession().setAttribute("message", "车位添加失败，请重试！");
                    request.getSession().setAttribute("messageType", "error");
                }
            }
            response.sendRedirect("parking_spot"); // Redirect to parking spot page
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "数据库操作失败：" + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("addParkingSpot.jsp");
        } finally {
            if (resultSet != null) resultSet.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
%>
