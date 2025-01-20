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
    // 加载 jdbc.properties 配置文件
    Properties properties = new Properties();
    InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
    properties.load(inputStream);

    String url = properties.getProperty("url");
    String dbUsername = properties.getProperty("user");
    String dbPassword = properties.getProperty("password");
    String dbDriver = properties.getProperty("driver");

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    ResultSet rrs = null;
    // 查询空闲的停车位
    try {
        // 加载 MySQL 驱动
        Class.forName(dbDriver);

        // 获取数据库连接
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // 创建 SQL 查询空闲停车位
        String sql = "SELECT * FROM parking_spot WHERE status = 'FREE'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        // 获取当前用户的车牌号
        String licensePlate = (String) session.getAttribute("licensePlate");
        if (licensePlate == null) {
            // 如果车牌号未设置，设置为默认值（此处可以处理为提示用户登录或设置车牌号）
            licensePlate = "未知车牌";
        }

        Integer userId = (Integer) session.getAttribute("userid");
        if (userId == null) {
            out.println("<script>alert('用户未登录！');window.location.href='login';</script>");
            return;
        }
        // 查询当前用户在 active_parking 表中的信息
        String sqlActiveParking = "SELECT * from active_parking WHERE userid = ?";
        PreparedStatement pstmt = conn.prepareStatement(sqlActiveParking);
        pstmt.setInt(1, userId);  // 使用当前用户的 userId
        rrs = pstmt.executeQuery();

        //结束使用代码
        String activeId_ = request.getParameter("activeId_");
        if (activeId_ != null && !activeId_.isEmpty()) {
            String spotId_ = request.getParameter("spotId_");
            String licensePlate_ = request.getParameter("licensePlate_");
            Timestamp entry_Time = Timestamp.valueOf(request.getParameter("entry_Time"));
            BigDecimal price_ = new BigDecimal(request.getParameter("price_"));
            // 获取当前时间（退出时间）
            Timestamp exitTime = new Timestamp(System.currentTimeMillis());
            // 判断当前时间是否大于入场时间
            if (exitTime.before(entry_Time)) {
                request.getSession().setAttribute("message", "当前时间小于入场时间，停车未开始！");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("userspot");
                return;  // 如果未开始，则退出方法
            }
            // 计算停车费：结束时间 - 开始时间 * 单位价格
            long durationMillis = exitTime.getTime() - entry_Time.getTime();
            BigDecimal durationHours = new BigDecimal(durationMillis).divide(new BigDecimal(1000 * 60 * 60), 2, BigDecimal.ROUND_HALF_UP);  // 计算小时数
            BigDecimal fee = durationHours.multiply(price_);

            // 插入数据到 parking_record 表
            String insertQuery = "INSERT INTO parking_record (license_plate, parking_spot_id, entry_time, exit_time, fee) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertQuery);
            pstmt.setString(1, licensePlate_);
            pstmt.setLong(2, Long.parseLong(spotId_));
            pstmt.setTimestamp(3, entry_Time);
            pstmt.setTimestamp(4, exitTime);
            pstmt.setBigDecimal(5, fee);

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                // 更新 active_parking 表，设置为结束
                String updateQuery = "DELETE FROM active_parking WHERE id = ?";
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setLong(1, Long.parseLong(activeId_));
                pstmt.executeUpdate();

                // 更新停车位状态为 'FREE'
                String updateSpotQuery = "UPDATE parking_spot SET status = 'FREE' WHERE id = ?";
                pstmt = conn.prepareStatement(updateSpotQuery);
                pstmt.setLong(1, Long.parseLong(spotId_));
                pstmt.executeUpdate();

                request.getSession().setAttribute("message", "停车记录结束，费用：" + fee + " 元");
                request.getSession().setAttribute("messageType", "success");
                response.sendRedirect("userspot");
            } else {
                request.getSession().setAttribute("message", "操作失败，未能记录停车信息！");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect("userspot");
            }

        }

%>
<!-- 当前用户的在停车辆信息 -->
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>当前在停的车辆</legend>
        </fieldset>
        <div class="layui-tab layui-tab-card">
            <table class="layui-table">
                <colgroup>
                    <col width="40">
                    <col width="100">
                    <col width="100">
                    <col width="100">
                    <col width="100">
                    <col width="100">
                </colgroup>
                <thead>
                <tr>
                    <th style="text-align:center;">ID</th>
                    <th style="text-align:center;">车牌号</th>
                    <th style="text-align:center;">停车位置</th>
                    <th style="text-align:center;">入场时间</th>
                    <th style="text-align:center;">停车费</th>
                    <th style="text-align:center;">操作</th>
                </tr>
                </thead>
                <tbody>
                <%
                    // 遍历查询当前用户的在停车辆信息
                    while (rrs.next()) {
                        long Id = rrs.getLong("id");
                        String license = rrs.getString("license_plate");
                        String location = rrs.getString("location");
                        Timestamp entryTime = rrs.getTimestamp("entry_time");
                        BigDecimal price = rrs.getBigDecimal("price");
                        // 获取当前时间（退出时间）
                        Timestamp nowtime = new Timestamp(System.currentTimeMillis());
                        // 计算停车费：结束时间 - 开始时间 * 单位价格
                        long feetime = nowtime.getTime() - entryTime.getTime();
                        BigDecimal duration = new BigDecimal(feetime).divide(new BigDecimal(1000 * 60 * 60), 2, BigDecimal.ROUND_HALF_UP);  // 计算小时数
                        BigDecimal feee = duration.multiply(price);
                %>
                <tr>
                    <td align="center"><%= Id %></td>
                    <td align="center"><%= license %></td>
                    <td align="center"><%= location %></td>
                    <td align="center"><fmt:formatDate value="<%= entryTime %>" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    <td align="center"><%= feee %></td>
                    <td align="center">
                        <form action="userspot" method="post" style="display:inline;">
                            <input type="hidden" name="activeId_" value="<%= rrs.getLong("id") %>">
                            <input type="hidden" name="spotId_" value="<%= rrs.getLong("spot_id") %>">
                            <input type="hidden" name="licensePlate_" value="<%= rrs.getString("license_plate") %>">
                            <input type="hidden" name="entry_Time" value="<%= rrs.getTimestamp("entry_time") %>">
                            <input type="hidden" name="price_" value="<%= rrs.getBigDecimal("price") %>">

                            <input type="submit" class="layui-btn layui-btn-danger layui-btn-mini" value="结束使用">
                        </form>
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
<!-- 列表 -->
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>空闲停车位</legend>
        </fieldset>
        <div class="layui-tab layui-tab-card">
            <table class="layui-table">
                <colgroup>
                    <col width="40"> <!-- 调整为更合适的宽度 -->
                    <col width="100">
                    <col width="100"> <!-- 调整停车位编号列宽度 -->
                    <col width="50"> <!-- 入场时间宽度 -->
                    <col width="100"> <!-- 离场时间宽度 -->
                    <col width="100"> <!-- 停车费列宽度 -->
                    <col width="160">  <!-- 操作列宽度 -->
                </colgroup>
                <thead>
                <tr>
                    <th style="text-align:center;">ID</th>
                    <th style="text-align:center;">位置</th>
                    <th style="text-align:center;">状态</th>
                    <th style="text-align:center;">金额/小时</th>
                    <th style="text-align:center;">创建时间</th>
                    <th style="text-align:center;">更新时间</th>
                    <th style="text-align:center;">操作</th>
                </tr>
                </thead>
                <tbody>
                <%
                    // 遍历查询结果并显示空闲停车位
                    while (rs.next()) {
                        String location = "暂无";  // 默认值为"暂无"
                        long id = rs.getLong("id");
                        location = rs.getString("location");
                        String status = rs.getString("status");
                        BigDecimal price = rs.getBigDecimal("price");
                        Timestamp createTime = rs.getTimestamp("create_time");
                        Timestamp updateTime = rs.getTimestamp("update_time");

                %>
                <tr>
                    <td align="center"><%= id %></td>
                    <td align="center"><%= location %></td>
                    <td align="center">
                        <span style="display: inline-block; padding: 6px 16px; border-radius: 10px;
                                background-color: <%= "FREE".equals(status) ? "#58d68d" : "#e74c3c" %>;
                                color: <%= "FREE".equals(status) ? "#f8f9f9" : "#f8f9f9" %>;
                                font-weight: bold;">
                            <%= "FREE".equals(status) ? "空闲" : "已占用" %>
                        </span>
                    </td>

                    <td align="center"><%= price %></td>
                    <td align="center"><fmt:formatDate value="<%= createTime %>" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    <td align="center"><fmt:formatDate value="<%= updateTime %>" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    <td align="center">
                        <!-- 开始使用按钮 -->
                        <form action="spot_use" method="post" style="display:inline;">
                            <input type="hidden" name="spotId" value="<%= rs.getLong("id") %>">
                            <input type="submit" class="layui-btn layui-btn-normal layui-btn-mini" value ="开始使用">
                        </form>
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
