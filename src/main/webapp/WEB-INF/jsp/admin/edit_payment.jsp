<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑支付单</title>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <%@ include file="../common/message.jsp" %>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 500px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
    <fieldset style="margin-bottom: 20px; border: none;">
        <legend style="font-size: 20px; font-weight: bold; text-align: center;">编辑支付单</legend>
    </fieldset>
    <%
        String paymentId = request.getParameter("paymentId");
        String amount = request.getParameter("amount");
        String paymentTime = request.getParameter("paymentTime");
        String paymentMethod = request.getParameter("paymentMethod");

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

            if (amount == null) {
                // 第一次加载页面，查询支付单信息
                String query = "SELECT amount, payment_time, payment_method FROM payment WHERE id = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setLong(1, Long.parseLong(paymentId));
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    amount = rs.getString("amount");
                    paymentTime = rs.getString("payment_time");
                    paymentMethod = rs.getString("payment_method");
                }
            } else {
                // 用户提交表单，更新支付单信息
                System.out.println(paymentId);
                System.out.println(amount);
                System.out.println(paymentTime);
                System.out.println(paymentMethod);
                String update = "UPDATE payment SET amount = ?, payment_time = ?, payment_method = ? WHERE id = ?";
                pstmt = conn.prepareStatement(update);
                pstmt.setBigDecimal(1, new BigDecimal(amount));
                pstmt.setTimestamp(2, Timestamp.valueOf(paymentTime));
                pstmt.setString(3, paymentMethod);
                pstmt.setLong(4, Long.parseLong(paymentId));
                int rows = pstmt.executeUpdate();

                if (rows > 0) {
                    // 添加成功，存储提示信息到 Session
                    request.getSession().setAttribute("message", "修改成功！");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    // 添加失败，存储提示信息到 Session
                    request.getSession().setAttribute("message", "修改失败，请重试");
                    request.getSession().setAttribute("messageType", "error");
                }
                // 重定向到 payment.jsp
                response.sendRedirect("payment");
            }
        } catch (Exception e) {

            request.getSession().setAttribute("message", "修改失败，请重试！");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("payment");
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    %>
    <form method="post" class="layui-form" style="margin-top: 20px;">
        <input type="hidden" name="paymentId" value="<%= paymentId %>">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">金额</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" name="amount" value="<%= amount %>" lay-verify="required" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">支付时间</label>
            <div class="layui-input-inline" style="width: 300px;">
                <input type="text" id="paymentTime" name="paymentTime" value="<%= paymentTime %>" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 100px;">支付方式</label>
            <div class="layui-input-inline" style="width: 300px;">
                <select name="paymentMethod" class="layui-input">
                    <option value="CASH" <%= "CASH".equals(paymentMethod) ? "selected" : "" %>>现金</option>
                    <option value="CARD" <%= "CARD".equals(paymentMethod) ? "selected" : "" %>>银行卡</option>
                    <option value="MOBILE" <%= "MOBILE".equals(paymentMethod) ? "selected" : "" %>>移动支付</option>
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

        // 初始化时间选择器
        laydate.render({
            elem: '#paymentTime', // 绑定支付时间输入框
            type: 'datetime'    // 日期时间选择器
        });
    });
</script>
</body>
</html>
