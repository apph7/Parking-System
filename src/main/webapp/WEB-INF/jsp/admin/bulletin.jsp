<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>公告管理</title>
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

    Statement stmt = null;

    // 获取分页参数
    String currentPageStr = request.getParameter("page");
    String limitStr = request.getParameter("limit");

    int currentPage = (currentPageStr != null) ? Integer.parseInt(currentPageStr) : 1;
    int limit = (limitStr != null) ? Integer.parseInt(limitStr) : 8;
    int offset = (currentPage - 1) * limit;

    List<Map<String, String>> bulletins = new ArrayList<>();
    int totalCount = 0;
    Class.forName(dbDriver);
    try ( Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword)) {
        // 查询公告总数
        String countQuery = "SELECT COUNT(*) FROM bulletin";
        try (PreparedStatement countStmt = conn.prepareStatement(countQuery);
             ResultSet rs = countStmt.executeQuery()) {
            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
        }

        // 查询公告数据
        String dataQuery = "SELECT id, title, content, publish_time, author, status, last_update_time,end_time " +
                "FROM bulletin ORDER BY end_time DESC LIMIT ?, ?";
        try (PreparedStatement dataStmt = conn.prepareStatement(dataQuery)) {
            dataStmt.setInt(1, offset);
            dataStmt.setInt(2, limit);
            try (ResultSet rs = dataStmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> bulletin = new HashMap<>();
                    bulletin.put("id", rs.getString("id"));
                    bulletin.put("title", rs.getString("title"));
                    String content = rs.getString("content");
                    // 限制只展示内容第一行的前30个字符
                    if (content != null) {
                        String[] lines = content.split("\n");  // 按行分割
                        if (lines.length > 0) {
                            content = lines[0].length() > 30 ? lines[0].substring(0, 30) + "..." : lines[0];
                        }
                    }
                    bulletin.put("content", content);
                    bulletin.put("end_time", rs.getString("end_time"));
                    bulletin.put("author", rs.getString("author"));
                    // 获取 end_time 和当前时间
                    String endTimeStr = rs.getString("end_time");
                    String status = "inactive"; // 默认状态为过期
                    if (endTimeStr != null) {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        try {
                            Date endDate = sdf.parse(endTimeStr);
                            Date currentDate = new Date();
                            // 判断是否活跃
                            if (currentDate.before(endDate)) {
                                status = "active";
                            }
                        } catch (ParseException e) {
                            e.printStackTrace();
                        }
                    }
                    // 将状态设置为活跃或过期
                    bulletin.put("status", status);
                    bulletin.put("last_update_time", rs.getString("last_update_time"));
                    bulletins.add(bulletin);
                }
            }
        }
    }
    // 处理删除操作
    String deleteId = request.getParameter("deleteId");
    if (deleteId != null) {
        try {
            Connection conn = null;
            PreparedStatement deleteStmt = null;
            String deleteSql = "DELETE FROM bulletin WHERE id = ?";
            // 加载驱动并获取连接
            Class.forName(dbDriver);
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);
            deleteStmt = conn.prepareStatement(deleteSql);
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
            response.sendRedirect("bulletin");
        } catch (SQLException e) {
            e.printStackTrace();
            // 添加失败，存储提示信息到 Session
            request.getSession().setAttribute("message", "异常！");
            request.getSession().setAttribute("messageType", "error");
        }
    }
%>

<!-- 公告列表 -->
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>
                公告管理
                <a href="edit_add_bulletin">
                    <button class="layui-btn">添加公告</button>
                </a>
            </legend>
        </fieldset>
        <div class="layui-tab layui-tab-card">
            <table class="layui-table">
                <colgroup>
                    <col width="50"> <!-- ID列宽度 -->
                    <col width="100">
                    <col width="300">
                    <col width="150">
                    <col width="50">
                    <col width="60">
                    <col width="160">
                </colgroup>
                <thead>
                <tr>
                    <th style="text-align:center;">ID</th>
                    <th style="text-align:center;">标题</th>
                    <th style="text-align:center;">内容</th>
                    <th style="text-align:center;">截至时间</th>
                    <th style="text-align:center;">作者</th>
                    <th style="text-align:center;">状态</th>
                    <th style="text-align:center;">操作</th>
                </tr>
                </thead>
                <tbody>
                <% for (Map<String, String> bulletin : bulletins) { %>
                <tr>

                    <td align="center"><a href="detail?id=<%= bulletin.get("id") %>"><%= bulletin.get("id") %></a></td>
                    <td><a href="detail?id=<%= bulletin.get("id") %>"><%= bulletin.get("title") %></a></td>
                    <td><a href="detail?id=<%= bulletin.get("id") %>"><%= bulletin.get("content") %></a></td>
                    <td align="center"><%= bulletin.get("end_time") %></td>
                    <td align="center"><%= bulletin.get("author") %></td>
                    <td align="center">
                        <span style="display: inline-block; padding: 6px 16px; border-radius: 10px;
                                background-color: <%= "active".equals(bulletin.get("status")) ? "#58d68d" : "#f1948a" %>;
                                color: <%= "active".equals(bulletin.get("status")) ? "#f8f9f9" : "#f8f9f9" %>;
                                font-weight: bold;">
                            <%= "active".equals(bulletin.get("status")) ? "活跃" : "过期" %>
                        </span>
                    </td>
                    <td align="center">
                        <!-- 删除按钮 -->
                        <form action="bulletin" method="get" style="display:inline;">
                            <input type="hidden" name="deleteId" value="<%= bulletin.get("id") %>">
                            <button type="submit" class="layui-btn layui-btn-danger layui-btn-mini">删除</button>
                        </form>
                        <!-- 修改按钮 -->
                        <form action="edit_bulletin" method="post" style="display:inline;">
                            <input type="hidden" name="editId" value="<%= bulletin.get("id") %>">
                            <button type="submit" class="layui-btn layui-btn-normal layui-btn-mini">修改</button>
                        </form>
                    </td>
                </tr>
                <% } %>

                </tbody>
            </table>
        </div>

        <!-- 分页信息 -->
        <div class="layui-row">
            <div class="layui-col-xs6">
                <p>共 <%= totalCount %> 条记录，当前显示第 <%= currentPage %> 页，每页 <%= limit %> 条。</p>
            </div>
            <div class="layui-col-xs6 layui-align-right">
                <a href="?page=<%= Math.max(1, currentPage - 1) %>&limit=<%= limit %>" class="layui-btn layui-btn-sm">上一页</a>
                <a href="?page=<%= Math.min((totalCount + limit - 1) / limit, currentPage + 1) %>&limit=<%= limit %>" class="layui-btn layui-btn-sm">下一页</a>
            </div>
        </div>
    </div>
</div>



<script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>


<script src="<%=request.getContextPath()%>/static/editor/js/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/static/layuiadmin/layui/layui.js"></script>

</body>
</html>
