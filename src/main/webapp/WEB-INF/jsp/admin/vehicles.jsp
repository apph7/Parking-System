<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>车辆记录</title>
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

    // 查询车辆记录
    try {
        // 加载 MySQL 驱动
        Class.forName(dbDriver);
        // 获取数据库连接
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // 创建 SQL 查询车辆记录
        String sql = "SELECT * FROM vehicles";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        // 处理删除操作
        String deleteId = request.getParameter("deleteId");
        if (deleteId != null) {
            try {
                String deleteSql = "DELETE FROM vehicles WHERE id = ?";
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
                // 重定向到车辆信息页面
                response.sendRedirect("vehicles");
            } catch (SQLException e) {
                e.printStackTrace();
                // 删除失败，存储提示信息到 Session
                request.getSession().setAttribute("message", "异常！");
                request.getSession().setAttribute("messageType", "error");
            }
        }

%>

<!-- 列表 -->
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>
                车辆列表
                <a href="edit_add_vehicles">
                    <button class="layui-btn">添加车辆</button>
                </a>
            </legend>
        </fieldset>
        <div class="layui-tab layui-tab-card">
            <table class="layui-table">
                <colgroup>
                    <col width="40">
                    <col width="40">
                    <col width="100">
                    <col width="100">
                    <col width="50">
                    <col width="100">
                    <col width="100">
                    <col width="150">
                </colgroup>
                <thead>
                <tr>
                    <th style="text-align:center;">ID</th>
                    <th style="text-align:center;">userID</th>
                    <th style="text-align:center;">车牌号</th>
                    <th style="text-align:center;">图片</th>
                    <th style="text-align:center;">车辆类型</th>
                    <th style="text-align:center;">车主姓名</th>
                    <th style="text-align:center;">创建时间</th>
                    <th style="text-align:center;">操作</th>
                </tr>
                </thead>
                <tbody>
                <%
                    // 遍历查询结果并显示
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        int user_id = rs.getInt("user_id");
                        String licensePlate = rs.getString("license_plate");
                        String vehicleType = rs.getString("vehicle_type");
                        String ownerName = rs.getString("owner_name");
                        Timestamp createTime = rs.getTimestamp("create_time");
                %>
                <tr>
                    <td align="center"><%= id %></td>
                    <td align="center"><%= user_id %></td>
                    <td align="center"><%= licensePlate %></td>
                    <td align="center" style="width: 50px;height:50px">
                        <img src="displayPhoto?id=<%= id %>" alt="Photo" style="width:90%;cursor:pointer" onclick="openModal(this)">
                    </td>

                    <!-- Modal for displaying the enlarged photo -->
                    <div id="myModal" class="modal">
                        <span class="close" onclick="closeModal()">&times;</span>
                        <img class="modal-content" id="img01">
                        <div id="caption"></div>
                    </div>

                    <!-- Add some basic CSS for styling the modal -->
                    <style>
                        /* Modal styles */
                        .modal {
                            display: none;
                            position: fixed;
                            z-index: 1;
                            left: 0;
                            top: 0;
                            width: 100%;
                            height: 100%;
                            overflow: auto;
                            background-color: rgb(0, 0, 0);
                            background-color: rgba(0, 0, 0, 0.9);
                        }

                        .modal-content {
                            margin: auto;
                            display: block;
                            width: 80%;
                            max-width: 700px;
                        }

                        /* Close button */
                        .close {
                            position: absolute;
                            top: 15px;
                            right: 35px;
                            color: #fff;
                            font-size: 40px;
                            font-weight: bold;
                            cursor: pointer;
                        }

                        .close:hover,
                        .close:focus {
                            color: #bbb;
                            text-decoration: none;
                            cursor: pointer;
                        }

                        #caption {
                            margin: 10px auto;
                            text-align: center;
                            color: #ccc;
                        }
                    </style>

                    <!-- JavaScript for opening and closing the modal -->
                    <script>
                        function openModal(imgElement) {
                            var modal = document.getElementById("myModal");
                            var modalImg = document.getElementById("img01");
                            var captionText = document.getElementById("caption");

                            modal.style.display = "block";
                            modalImg.src = imgElement.src;
                            captionText.innerHTML = imgElement.alt;
                        }

                        function closeModal() {
                            var modal = document.getElementById("myModal");
                            modal.style.display = "none";
                        }
                    </script>

                    <td align="center"><%= vehicleType %></td>
                    <td align="center"><%= ownerName %></td>
                    <td align="center">
                        <fmt:formatDate value="<%= createTime %>" pattern="yyyy-MM-dd HH:mm:ss" />
                    </td>
                    <td align="center">
                        <!-- 删除按钮 -->
                        <form action="vehicles" method="post" style="display:inline;">
                            <input type="hidden" name="deleteId" value="<%= id %>">
                            <button type="submit" class="layui-btn layui-btn-danger layui-btn-mini">删除</button>
                        </form>
                        <!-- 修改按钮 -->
                        <form action="edit_vehicles" method="post" style="display:inline;">
                            <input type="hidden" name="editId" value="<%= id %>">
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
