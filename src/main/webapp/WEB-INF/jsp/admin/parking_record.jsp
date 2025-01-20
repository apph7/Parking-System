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
    ResultSet rsSpot = null;

    // 查询停车记录
    try {
        // 加载 MySQL 驱动
        Class.forName(dbDriver);

        // 获取数据库连接
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // 创建 SQL 查询停车记录
        String sql = "SELECT id, license_plate, parking_spot_id, entry_time, exit_time, fee, status, create_time " +
                "FROM parking_record " +
                "ORDER BY create_time DESC";

        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        // 处理删除操作
        String deleteId = request.getParameter("deleteId");
        if (deleteId != null) {
            try {
                String deleteSql = "DELETE FROM parking_record WHERE id = ?";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                deleteStmt.setLong(1, Long.parseLong(deleteId));
                int rowsAffected = deleteStmt.executeUpdate();
                if (rowsAffected > 0) {
                    // 添加成功，存储提示信息到 Session
                    request.getSession().setAttribute("message", "删除成功！");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    // 添加失败，存储提示信息到 Session
                    request.getSession().setAttribute("message", "删除 失败！");
                    request.getSession().setAttribute("messageType", "error");
                }
                // 重定向到 user_info.jsp
                response.sendRedirect("parking_record");
            } catch (SQLException e) {
                e.printStackTrace();
                // 添加失败，存储提示信息到 Session
                request.getSession().setAttribute("message", "异常！");
                request.getSession().setAttribute("messageType", "error");
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
                    <th style="text-align:center;">停车位编号</th> <!-- 新增加的列 -->
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
                        String status = rs.getString("status");
                        Timestamp createTime = rs.getTimestamp("create_time");

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
                    <td align="center"><%= rs.getLong("id") %></td>
                    <td align="center"><%= licensePlate %></td>

                    <td align="center"><%= location %></td> <!-- 显示 parking_spot 中的 spot_number -->
                    <td align="center"><fmt:formatDate value="<%= entryTime %>" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    <td align="center"><fmt:formatDate value="<%= exitTime %>" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    <td align="center"><%= fee %></td>
                    <td align="center"><%= status %></td>
                    <td align="center"><fmt:formatDate value="<%= createTime %>" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                    <td align="center">
                        <!-- 删除按钮 -->
                        <form action="parking_record" method="get" style="display:inline;">
                            <input type="hidden" name="deleteId" value="<%= rs.getLong("id") %>">
                            <button type="submit" class="layui-btn layui-btn-danger layui-btn-mini">删除</button>
                        </form>
                        <!-- 修改按钮 -->
                        <form action="edit_record" method="post" style="display:inline;">
                            <input type="hidden" name="editId" value="<%= rs.getLong("id") %>">
                            <button type="submit" class="layui-btn layui-btn-normal layui-btn-mini">修改</button>
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
