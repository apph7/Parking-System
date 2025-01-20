<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.InputStream" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>开始使用停车位</title>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <%@ include file="../common/message.jsp" %>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 500px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
    <fieldset style="margin-bottom: 20px; border: none;">
        <legend style="font-size: 20px; font-weight: bold; text-align: center;">开始使用停车位</legend>
    </fieldset>
    <%
        // 获取Session中的用户ID
        Integer userId = (Integer) session.getAttribute("userid");

        String spotId = request.getParameter("spotId");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String location = "";
        BigDecimal price = BigDecimal.ZERO;
        List<String> vehicles = new ArrayList<>();

        try {
            // 加载数据库配置
            Properties properties = new Properties();
            InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
            properties.load(inputStream);
            String url = properties.getProperty("url");
            String dbUsername = properties.getProperty("user");
            String dbPassword = properties.getProperty("password");
            String dbDriver = properties.getProperty("driver");

            Class.forName(dbDriver);
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            if (spotId != null) {
                // 获取停车位信息
                String spotQuery = "SELECT location, price FROM parking_spot WHERE id = ?";
                pstmt = conn.prepareStatement(spotQuery);
                pstmt.setLong(1, Long.parseLong(spotId));
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    location = rs.getString("location");
                    price = rs.getBigDecimal("price");
                }

                // 获取用户名下的车辆
                String vehicleQuery = "SELECT license_plate FROM vehicles WHERE user_id = ?";
                pstmt = conn.prepareStatement(vehicleQuery);
                pstmt.setLong(1, userId);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    vehicles.add(rs.getString("license_plate"));
                }
            } else {
                double money = (double) session.getAttribute("money");
                if(money < 0){
                    request.getSession().setAttribute("message", "余额不足，请充值！");
                    request.getSession().setAttribute("messageType", "error");
                    response.sendRedirect("userspot");
                }
                String Id = request.getParameter("Id");
                String license_plate = request.getParameter("license_plate");
                String startTime = request.getParameter("startTime");
                String priceStr = request.getParameter("price");
                String locationstr = request.getParameter("location");
                if (priceStr != null && !priceStr.isEmpty()) {
                    // 将字符串转换为 BigDecimal 类型
                    price = new BigDecimal(priceStr);
                }
                // 处理提交的数据并插入到 active_parking 表
                if (license_plate != null && !license_plate.isEmpty() && startTime != null && !startTime.isEmpty()) {
                    String insertQuery = "INSERT INTO active_parking (spot_id, userid, license_plate, entry_time, price,location) VALUES (?, ?, ?, ?, ? ,?)";
                    pstmt = conn.prepareStatement(insertQuery);
                    pstmt.setLong(1, Long.parseLong(Id));
                    pstmt.setInt(2, userId);
                    pstmt.setString(3, license_plate);
                    pstmt.setTimestamp(4, new Timestamp(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(startTime).getTime()));
                    System.out.println(price);
                    pstmt.setBigDecimal(5, price); // 确保价格正确插入
                    pstmt.setString(6, locationstr); // 确保价格正确插入pstmt.setString(3, license_plate);

                    int rowsInserted = pstmt.executeUpdate();

                    if (rowsInserted > 0) {
                        // 更新 parking_spot 表的状态为已使用
                        String updateSpotStatusQuery = "UPDATE parking_spot SET status = 'OCCUPIED' WHERE id = ?";
                        pstmt = conn.prepareStatement(updateSpotStatusQuery);
                        pstmt.setLong(1, Long.parseLong(Id));
                        pstmt.executeUpdate();

                        request.getSession().setAttribute("message", "使用成功！");
                        request.getSession().setAttribute("messageType", "success");
                        response.sendRedirect("userspot");
                    } else {
                        request.getSession().setAttribute("message", "操作失败，未能更新数据！");
                        request.getSession().setAttribute("messageType", "error");
                        response.sendRedirect("spot_use");
                    }
                } else {
                    out.println("<script>alert('请选择车辆和开始时间。'); window.history.back();</script>");
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

    <form method="post" class="layui-form" action="spot_use">
        <input type="hidden" name="Id" value="<%= spotId %>">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">停车位位置</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="location" value="<%= location %>" readonly class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">单位价格</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="price" value="<%= price %>" readonly class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">选择车辆</label>
            <div class="layui-input-inline" style="width: 300px;">
                <select name="license_plate" lay-verify="required" class="layui-input">
                    <option value="">请选择车辆</option>
                    <% for (String vehicle : vehicles) { %>
                    <option value="<%= vehicle %>"><%= vehicle %></option>
                    <% } %>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">开始时间</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="startTime" id="startTime" lay-verify="required" class="layui-input" placeholder="选择开始时间">
            </div>
        </div>

        <div class="layui-form-item" style="text-align: center;">
            <input type="submit" class="layui-btn" value="提交">
        </div>
    </form>
</div>
<script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>

<script>
    layui.use(['laydate'], function () {
        var laydate = layui.laydate;

        // 日期选择器
        laydate.render({
            elem: '#startTime',
            type: 'datetime', // 设置为日期时间选择
            min: new Date().toLocaleString() // 设置最小时间为当前时间
        });
    });
</script>
</body>
</html>
