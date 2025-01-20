<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑停车记录</title>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <%@ include file="../common/message.jsp" %>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 500px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
    <fieldset style="margin-bottom: 20px; border: none;">
        <legend style="font-size: 20px; font-weight: bold; text-align: center;">编辑停车记录</legend>
    </fieldset>
    <%
        String editId = request.getParameter("editId"); // 传入的编辑记录 ID
        String id = request.getParameter("id"); // 用于区分是否更新操作

        String licensePlate = request.getParameter("licensePlate");
        String location = request.getParameter("location");
        String entryTime = request.getParameter("entryTime");
        String exitTime = request.getParameter("exitTime");
        String fee = request.getParameter("fee");
        String status = request.getParameter("status");

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
                // 第一次加载页面，查询记录信息
                String query = "SELECT p.license_plate, p.parking_spot_id, ps.location, p.entry_time, p.exit_time, p.fee, p.status " +
                        "FROM parking_record p " +
                        "JOIN parking_spot ps ON p.parking_spot_id = ps.id " +
                        "WHERE p.id = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setLong(1, Long.parseLong(editId));
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    licensePlate = rs.getString("license_plate");
                    location = rs.getString("location");
                    entryTime = rs.getString("entry_time");
                    exitTime = rs.getString("exit_time");
                    fee = rs.getString("fee");
                    status = rs.getString("status");
                }
            } else {
                // 更新记录
                long parkingSpotId = -1;
                // 查找车位 ID
                String locationQuery = "SELECT id FROM parking_spot WHERE location = ?";
                pstmt = conn.prepareStatement(locationQuery);
                pstmt.setString(1, location);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    parkingSpotId = rs.getLong("id");
                } else {
                    request.getSession().setAttribute("message", "未找到该车位对应 ID！");
                    request.getSession().setAttribute("messageType", "error");
                    response.sendRedirect("parking_record");
                    return;
                }

                // 更新停车记录表
                String updateQuery = "UPDATE parking_record SET license_plate = ?, parking_spot_id = ?, entry_time = ?, exit_time = ?, fee = ?, status = ? WHERE id = ?";
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setString(1, licensePlate);
                pstmt.setLong(2, parkingSpotId);
                pstmt.setTimestamp(3, Timestamp.valueOf(entryTime));
                pstmt.setTimestamp(4, exitTime != null && !exitTime.isEmpty() ? Timestamp.valueOf(exitTime) : null);
                pstmt.setBigDecimal(5, new BigDecimal(fee));
                pstmt.setString(6, status);
                pstmt.setLong(7, Long.parseLong(id));

                int rowsUpdated = pstmt.executeUpdate();
                if (rowsUpdated > 0) {
                    request.getSession().setAttribute("message", "修改成功！");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    request.getSession().setAttribute("message", "修改失败，请重试！");
                    request.getSession().setAttribute("messageType", "error");
                }
                response.sendRedirect("parking_record");
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
    <form method="post" class="layui-form" style="margin-top: 20px;" action="edit_record">
        <input type="hidden" name="id" value="<%= editId %>">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">车牌号</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="licensePlate" value="<%= licensePlate %>" lay-verify="required" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">车位位置</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="location" value="<%= location %>" lay-verify="required" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">进入时间</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" id="entryTime" name="entryTime" value="<%= entryTime %>" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">离开时间</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" id="exitTime" name="exitTime" value="<%= exitTime %>" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">费用</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="fee" value="<%= fee %>" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">状态</label>
            <div class="layui-input-inline" style="width: 300px;">
                <select name="status" class="layui-input">
                    <option value="ACTIVE" <%= "ACTIVE".equals(status) ? "selected" : "" %>>进行中</option>
                    <option value="COMPLETED" <%= "COMPLETED".equals(status) ? "selected" : "" %>>已完成</option>
                    <option value="CANCELLED" <%= "CANCELLED".equals(status) ? "selected" : "" %>>已取消</option>
                </select>
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

        laydate.render({
            elem: '#entryTime',
            type: 'datetime'
        });

        laydate.render({
            elem: '#exitTime',
            type: 'datetime'
        });
    });
</script>
</body>
</html>
