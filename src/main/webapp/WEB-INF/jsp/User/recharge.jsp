<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>充值界面</title>
    <%@ include file="../common/message.jsp" %>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>
    <script src="//code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 500px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
    <fieldset style="margin-bottom: 20px; border: none;">
        <legend style="font-size: 20px; font-weight: bold; text-align: center;">充值界面</legend>
    </fieldset>

    <%
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
        Class.forName(dbDriver);
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // 获取 session 信息
        Integer userId = (Integer) session.getAttribute("userid");
        String username = (String) session.getAttribute("username");
        Double currentMoney = (Double) session.getAttribute("money");

        if (currentMoney == null) {
            currentMoney = 0.0;
        }

        // 处理充值逻辑
        String confirmedAmount = request.getParameter("confirmedAmount");
        if (confirmedAmount != null) {
            try {
                BigDecimal rechargeAmount = new BigDecimal(confirmedAmount);

                // 更新数据库中的余额
                String updateBalanceSql = "UPDATE guest SET money = money + ? WHERE id = ?";
                pstmt = conn.prepareStatement(updateBalanceSql);
                pstmt.setBigDecimal(1, rechargeAmount);
                pstmt.setInt(2, userId);
                pstmt.executeUpdate();

                // 更新 session 中的余额
                currentMoney += rechargeAmount.doubleValue();
                session.setAttribute("money", currentMoney);

                // 提示成功
                request.getSession().setAttribute("message", "充值成功！金额：" + rechargeAmount + " 元");
                request.getSession().setAttribute("messageType", "success");

            } catch (Exception e) {
                request.getSession().setAttribute("message", "充值失败！" + e.getMessage());
                request.getSession().setAttribute("messageType", "error");
            } finally {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        }
    %>

    <!-- 显示当前余额 -->
    <div style="text-align: center; margin-bottom: 20px;">
        <p style="font-size: 18px;">当前余额：<strong><%= currentMoney %> 元</strong></p>
    </div>

    <!-- 充值选项 -->
    <div style="text-align: center;">
        <button class="layui-btn layui-btn-normal recharge-button" data-amount="30">充值 30 元</button>
        <button class="layui-btn layui-btn-normal recharge-button" data-amount="50">充值 50 元</button>
        <button class="layui-btn layui-btn-normal recharge-button" data-amount="100">充值 100 元</button>
        <button class="layui-btn layui-btn-normal recharge-button" data-amount="200">充值 200 元</button>
    </div>
</div>

<!-- 弹出框 -->
<div id="recharge-confirm-modal" style="display: none; padding: 20px;">
    <form method="post" class="layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">用户 ID：</label>
            <div class="layui-input-inline">
                <input type="text" name="userid" value="<%= userId %>" readonly class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">用户名：</label>
            <div class="layui-input-inline">
                <input type="text" name="username" value="<%= username %>" readonly class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">充值金额：</label>
            <div class="layui-input-inline">
                <input type="text" name="confirmedAmount" id="confirmedAmount" readonly class="layui-input">
            </div>
        </div>
        <div class="layui-form-item" style="text-align: center;">
            <button type="submit" class="layui-btn layui-btn-danger">确认充值</button>
        </div>
    </form>
</div>

<script>
    layui.use(['layer'], function () {
        var layer = layui.layer;

        // 绑定充值按钮点击事件
        $(".recharge-button").click(function () {
            var amount = $(this).data("amount");

            // 设置弹出框金额
            $("#confirmedAmount").val(amount);

            // 显示确认框
            layer.open({
                type: 1,
                title: '确认充值',
                content: $('#recharge-confirm-modal'),
                area: ['400px', '330px'],
                shadeClose: true,  // 点击空白区域关闭弹框
                end: function() {  // 点击弹框关闭时，刷新页面
                    location.reload();
                }
            });
        });
    });
</script>
</body>
</html>
