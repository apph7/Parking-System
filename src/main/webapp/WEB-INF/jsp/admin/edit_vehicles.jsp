<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.Properties, java.io.InputStream, java.io.IOException" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑车辆信息</title>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <%@ include file="../common/message.jsp" %>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 500px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
    <fieldset style="margin-bottom: 20px; border: none;">
        <legend style="font-size: 20px; font-weight: bold; text-align: center;">编辑车辆信息</legend>
    </fieldset>

    <%
        String editId = request.getParameter("editId"); // 获取编辑记录 ID
        String id = request.getParameter("id"); // 用于区分是否更新操作

        String licensePlate = request.getParameter("licensePlate");
        String vehicleType = request.getParameter("vehicleType");
        String ownerName = request.getParameter("ownerName");


        // JDBC connection setup
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
                // 第一次加载页面，查询车辆信息
                String query = "SELECT license_plate, vehicle_type, owner_name, photo FROM vehicles WHERE id = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setLong(1, Long.parseLong(editId));
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    licensePlate = rs.getString("license_plate");
                    vehicleType = rs.getString("vehicle_type");
                    ownerName = rs.getString("owner_name");
                }
            }
        } catch (Exception e) {
            out.println("<script>alert('操作失败：" + e.getMessage() + "');</script>");
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    %>

    <form method="post" class="layui-form" style="margin-top: 20px;" action="uploadPhoto" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= editId %>">

        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">车牌号</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="licensePlate" value="<%= licensePlate %>" lay-verify="required" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">车辆类型</label>
            <div class="layui-input-inline" style="width: 300px;">
                <select name="vehicleType" class="layui-input">
                    <option value="CAR" <%= "CAR".equals(vehicleType) ? "selected" : "" %>>轿车</option>
                    <option value="SUV" <%= "SUV".equals(vehicleType) ? "selected" : "" %>>SUV</option>
                    <option value="TRUCK" <%= "TRUCK".equals(vehicleType) ? "selected" : "" %>>卡车</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">车主姓名</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="ownerName" value="<%= ownerName %>" class="layui-input">
            </div>
        </div>


        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px; font-weight: bold; color: #333;">车辆图片</label>
            <div class="layui-input-inline" style="width: 300px; position: relative;">
                <input type="file" id="photo" name="photo" accept="image/*" class="layui-input" style="padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; background-color: #f9f9f9; color: #333; cursor: pointer;">
                <span style="position: absolute; top: 50%; right: 12px; transform: translateY(-50%); font-size: 14px; color: #999;">上传</span>
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
    layui.use('form', function(){
        var form = layui.form;
        form.verify({
            required: function(value){
                if(!value){
                    return '此项不能为空';
                }
            }
        });
    });
</script>
</body>
</html>
