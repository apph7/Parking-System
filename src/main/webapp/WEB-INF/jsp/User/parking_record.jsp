<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>停车记录</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery.js"></script>
    <script src="<%=request.getContextPath()%>/static/js/md5.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <%@ include file="../common/message.jsp" %>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/style/admin.css" media="all">
    <link href="//unpkg.com/layui@2.9.21/dist/css/layui.css" rel="stylesheet">
</head>

<body>
<%
    // 获取 user_id
    Integer userId = (Integer) session.getAttribute("userid");  // 从 session 获取用户ID
    if (userId == null) {
        response.sendRedirect("User/index"); // 如果未找到 userId，重定向到登录页面
        return;
    }

    // 加载 jdbc.properties 配置文件
    Properties properties = new Properties();
    InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
    properties.load(inputStream);

    String url = properties.getProperty("url");
    String dbUsername = properties.getProperty("user");
    String dbPassword = properties.getProperty("password");
    String dbDriver = properties.getProperty("driver");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    ResultSet rsSpot = null;

    // 查询停车记录
    try {
        // 加载 MySQL 驱动
        Class.forName(dbDriver);

        // 获取数据库连接
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // 创建 SQL 查询停车记录，增加 user_id 作为查询条件
        String sql = "SELECT record_id, license_plate, vehicle_type, parking_spot_id, entry_time, exit_time, fee, parking_status, parking_create_time FROM vehicle_parking WHERE user_id = ? ORDER BY parking_create_time DESC";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId); // 设置 user_id 参数
        rs = stmt.executeQuery();

        // 处理删除操作
        String deleteId = request.getParameter("deleteId");
        if (deleteId != null) {
            try {
                String deleteSql = "DELETE FROM parking_record WHERE id = ?";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                deleteStmt.setLong(1, Long.parseLong(deleteId));
                int rowsAffected = deleteStmt.executeUpdate();
                if (rowsAffected > 0) {
                    // 删除成功，存储提示信息到 Session
                    request.getSession().setAttribute("message", "删除成功！");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    // 删除失败，存储提示信息到 Session
                    request.getSession().setAttribute("message", "删除失败！");
                    request.getSession().setAttribute("messageType", "error");
                }
                // 重定向到停车记录页面
                response.sendRedirect("userrecord");
            } catch (SQLException e) {
                e.printStackTrace();
                // 异常，存储提示信息到 Session
                request.getSession().setAttribute("message", "异常！");
                request.getSession().setAttribute("messageType", "error");
            }
        }

        // 处理支付操作
        String payId = request.getParameter("payId");
        if (payId != null) {
            try {
                // 获取支付金额
                String feeStr = request.getParameter("feee");
                BigDecimal fee = new BigDecimal(feeStr);  // 将支付金额转换为 BigDecimal 类型

                // 获取当前用户的账户余额
                double money = (double) session.getAttribute("money");

                // 判断余额是否足够支付
                if (fee.compareTo(new BigDecimal(money)) > 0) {
                    // 余额不足，返回提示
                    request.getSession().setAttribute("message", "余额不足，无法支付！");
                    request.getSession().setAttribute("messageType", "error");
                    response.sendRedirect("userrecord");  // 可根据需求重定向到充值界面
                    return; // 停止后续操作
                }

                // 余额足够，更新用户余额
                BigDecimal moneyDecimal = new BigDecimal(Double.toString(money)); // 将余额转换为 BigDecimal
                BigDecimal newBalanceDecimal = moneyDecimal.subtract(fee); // 余额减去支付金额
                BigDecimal roundedBalance = newBalanceDecimal.setScale(2, BigDecimal.ROUND_HALF_UP); // 保留两位小数，四舍五入
                double newBalance = roundedBalance.doubleValue(); // 转回 double 用于存储到数据库

                String updateUserBalance = "UPDATE guest SET money = ? WHERE id = ?";
                PreparedStatement pstmt = conn.prepareStatement(updateUserBalance);
                pstmt.setDouble(1, newBalance);
                pstmt.setInt(2, userId);  // 获取当前用户ID
                pstmt.executeUpdate();
                // 更新金额
                session.setAttribute("money", newBalance);  // 更新 session 中的 money 值

                // 更新停车记录支付状态
                String updatePaymentStatus = "UPDATE parking_record SET status = 'COMPLETED' WHERE id = ?";
                pstmt = conn.prepareStatement(updatePaymentStatus);
                pstmt.setString(1, payId);  // 使用传入的支付ID
                pstmt.executeUpdate();

                // 插入支付记录到 payment 表
                String insertPaymentSql = "INSERT INTO payment (parking_record_id, amount, payment_method) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(insertPaymentSql);
                pstmt.setString(1, payId);  // 使用停车记录ID
                pstmt.setBigDecimal(2, fee);  // 支付金额
                pstmt.setString(3, "MOBILE");  // 默认支付方式为 MOBILE，可根据实际需求修改
                pstmt.executeUpdate();
                //提示刷新

                // 支付成功，跳转或提示用户
                request.getSession().setAttribute("message", "支付成功！");
                request.getSession().setAttribute("messageType", "success");
                response.sendRedirect("userrecord");  // 可根据需求重定向到相应页面

            } catch (SQLException e) {
                e.printStackTrace();
                // 异常，存储提示信息到 Session
                request.getSession().setAttribute("message", "异常！请重试");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("userrecord");
            } catch (NumberFormatException e) {
                // 处理金额格式不正确的情况
                e.printStackTrace();
                request.getSession().setAttribute("message", "支付金额格式不正确！");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("userrecord");
            }
        }

%>

<!-- 列表 -->
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>停车记录</legend>
        </fieldset>
        <div class="layui-tab layui-tab-card">
            <table class="layui-table">
                <colgroup>
                    <col width="40"> <!-- 调整为更合适的宽度 -->
                    <col width="100">
                    <col width="100"> <!-- 调整停车位编号列宽度 -->
                    <col width="100"> <!-- 入场时间宽度 -->
                    <col width="100"> <!-- 离场时间宽度 -->
                    <col width="40"> <!-- 停车费列宽度 -->
                    <col width="60"> <!-- 状态列宽度 -->
                    <col width="100"> <!-- 创建时间宽度 -->
                    <col width="160">  <!-- 操作列宽度 -->
                </colgroup>
                <thead>
                <tr>
                    <th style="text-align:center;">ID</th>
                    <th style="text-align:center;">车牌号</th>
                    <th style="text-align:center;">停车位编号</th>
                    <th style="text-align:center;">入场时间</th>
                    <th style="text-align:center;">离场时间</th>
                    <th style="text-align:center;">停车费</th>
                    <th style="text-align:center;">状态</th>
                    <th style="text-align:center;">创建时间</th>
                    <th style="text-align:center;">操作</th>
                </tr>
                </thead>
                <tbody>
                <%
                    // 遍历查询结果并显示
                    while (rs.next()) {
                        String licensePlate = rs.getString("license_plate");
                        long parkingSpotId = rs.getLong("parking_spot_id");
                        Timestamp entryTime = rs.getTimestamp("entry_time");
                        Timestamp exitTime = rs.getTimestamp("exit_time");
                        BigDecimal fee = rs.getBigDecimal("fee");
                        String status = rs.getString("parking_status");
                        Timestamp createTime = rs.getTimestamp("parking_create_time");

                        // 查询 parking_spot 表以获取 spot_number
                        String location = "暂无";  // 默认值为"暂无"
                        try {
                            String spotSql = "SELECT location FROM parking_spot WHERE id = ?";
                            PreparedStatement spotStmt = conn.prepareStatement(spotSql);
                            spotStmt.setLong(1, parkingSpotId);
                            rsSpot = spotStmt.executeQuery();
                            if (rsSpot.next()) {
                                location = rsSpot.getString("location");
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                %>
                <tr>
                    <td align="center"><%= rs.getLong("record_id") %></td>
                    <td align="center"><%= licensePlate %></td>
                    <td align="center"><%= location %></td> <!-- 显示停车位信息 -->
                    <td align="center"><fmt:formatDate value="<%= entryTime %>" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    <td align="center"><fmt:formatDate value="<%= exitTime %>" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    <td align="center"><%= fee %></td>
                    <td align="center"><%= status %></td>
                    <td align="center"><fmt:formatDate value="<%= createTime %>" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    <td align="center">
                        <!-- 动态按钮 -->

                        <% if ("ACTIVE".equals(status)) { %>
                        <!-- 支付按钮 -->
                        <form action="userrecord" method="post" style="display:inline;">
                            <input type="hidden" name="payId" value="<%= rs.getLong("record_id") %>">
                            <input type="hidden" name="feee" value="<%= fee %>">
                            <input type="submit" class="layui-btn layui-btn-normal layui-btn-mini" value="支付">
                        </form>
                        <% } else if ("CANCELLED".equals(status) || "COMPLETED".equals(status)) { %>
                        <!-- 删除按钮 -->
                        <form action="userrecord" method="get" style="display:inline;">
                            <input type="hidden" name="deleteId" value="<%= rs.getLong("record_id") %>">
                            <button type="submit" class="layui-btn layui-btn-danger layui-btn-mini">删除</button>
                        </form>
                        <% } %>

                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (rsSpot != null) rsSpot.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<script src="<%=request.getContextPath()%>/static/editor/js/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/static/layuiadmin/layui/layui.js"></script>

</body>
</html>
