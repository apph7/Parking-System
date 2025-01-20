<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>支付账单</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="//unpkg.com/layui@2.9.21/dist/css/layui.css" rel="stylesheet">
    <script>
        function enableEdit(rowId) {
            document.querySelectorAll(`.edit-${rowId}`).forEach(element => {
                element.removeAttribute("readonly");
                element.classList.add("layui-input");
            });
            document.getElementById(`saveBtn-${rowId}`).style.display = "inline";
            document.getElementById(`cancelBtn-${rowId}`).style.display = "inline";
        }

        function cancelEdit(rowId) {
            document.querySelectorAll(`.edit-${rowId}`).forEach(element => {
                element.setAttribute("readonly", "readonly");
                element.classList.remove("layui-input");
            });
            document.getElementById(`saveBtn-${rowId}`).style.display = "none";
            document.getElementById(`cancelBtn-${rowId}`).style.display = "none";
        }
    </script>
</head>
<body>
<script>
    $(document).ready(function () {
        const message = "<%= session.getAttribute("message") %>";
        const messageType = "<%= session.getAttribute("messageType") %>";

        if (message && messageType === "success") {
            showSuccessMessage(message);
        } else if (message && messageType === "error") {
            showErrorMessage(message);
        }

        // 清除 session 中的提示信息
        <% session.removeAttribute("message"); %>
        <% session.removeAttribute("messageType"); %>
    });
    // 显示错误信息
    function showErrorMessage(message) {
        const errorMessage = $("#errorMessage");
        errorMessage.text(message).fadeIn();
        setTimeout(function () {
            errorMessage.fadeOut();
        }, 3000);
    }

    // 显示成功信息
    function showSuccessMessage(message) {
        const successMessage = $("#successMessage");
        successMessage.text(message).fadeIn();
        setTimeout(function () {
            successMessage.fadeOut();
        }, 3000);
    }

</script>

<div id="errorMessage" style="display: none; position: fixed; top: 20px; left: 50%; transform: translateX(-50%); padding: 10px 20px; background-color: #f8d7da; color: #842029; border: 1px solid #f5c2c7; border-radius: 5px; font-size: 14px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); z-index: 1000;">
    登录失败
</div>
<div id="successMessage" style="display: none; position: fixed; top: 20px; left: 50%; transform: translateX(-50%); padding: 10px 20px; background-color: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; border-radius: 5px; font-size: 14px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); z-index: 1000;">
    登录成功
</div>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>支付账单</legend>
        </fieldset>
        <div class="layui-tab layui-tab-card">
            <table class="layui-table">
                <colgroup>
                    <col width="80">
                    <col width="150">
                    <col width="150">
                    <col width="100">
                    <col width="100">
                    <col width="200">
                    <col width="250">
                </colgroup>
                <thead>
                <tr>
                    <th style="text-align:center;">支付单ID</th>
                    <th style="text-align:center;">车牌号</th>
                    <th style="text-align:center;">车位编号</th>
                    <th style="text-align:center;">支付金额</th>
                    <th style="text-align:center;">支付方式</th>
                    <th style="text-align:center;">支付时间</th>
                    <th style="text-align:center;">操作</th>
                </tr>
                </thead>
                <tbody>
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

                    try {
                        Class.forName(dbDriver);
                        conn = DriverManager.getConnection(url, dbUsername, dbPassword);
                        //删除
                        String deleteId = request.getParameter("deleteId");
                        if (deleteId != null) {
                            try {
                                String deleteSql = "DELETE FROM payment WHERE id = ?";
                                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                                    deleteStmt.setLong(1, Long.parseLong(deleteId));
                                    int rowsAffected = deleteStmt.executeUpdate();
                                    if (rowsAffected > 0) {
                                        session.setAttribute("message", "删除成功！");
                                        session.setAttribute("messageType", "success");
                                    } else {
                                        session.setAttribute("message", "删除失败，记录不存在！");
                                        session.setAttribute("messageType", "error");
                                    }
                                    response.sendRedirect("payment");
                                }
                            } catch (Exception e) {
                                session.setAttribute("message", "删除失败：" + e.getMessage());
                                session.setAttribute("messageType", "error");
                                response.sendRedirect("payment");
                            }
                        }


                        // 查询支付记录
                        String sql = "SELECT id, parking_record_id, amount, payment_time, payment_method FROM payment";;
                        pstmt = conn.prepareStatement(sql);
                        ResultSet rs = pstmt.executeQuery();

                        while (rs.next()) {
                            long paymentId = rs.getLong("id");
                            BigDecimal amount = rs.getBigDecimal("amount");
                            Timestamp paymentTime = rs.getTimestamp("payment_time");
                            String paymentMethod = rs.getString("payment_method");

                            // 查询车牌号和车位编号
                            String licensePlate = "未知车牌";
                            String location = "未知车位";
                            try (PreparedStatement recordStmt = conn.prepareStatement(
                                    "SELECT license_plate, parking_spot_id FROM parking_record WHERE id = ?")) {
                                recordStmt.setLong(1, rs.getLong("parking_record_id"));
                                try (ResultSet recordRs = recordStmt.executeQuery()) {
                                    if (recordRs.next()) {
                                        licensePlate = recordRs.getString("license_plate");
                                        long spotId = recordRs.getLong("parking_spot_id");

                                        try (PreparedStatement spotStmt = conn.prepareStatement(
                                                "SELECT location FROM parking_spot WHERE id = ?")) {
                                            spotStmt.setLong(1, spotId);
                                            try (ResultSet spotRs = spotStmt.executeQuery()) {
                                                if (spotRs.next()) {
                                                    location = spotRs.getString("location");
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                %>
                <tr>
                    <td align="center"><%= paymentId %></td>
                    <td align="center"><%= licensePlate %></td>
                    <td align="center"><%= location %></td>
                    <td align="center"><%= amount %></td>
                    <td align="center"><%= paymentMethod %></td>
                    <td align="center">
                        <fmt:formatDate value="<%= paymentTime %>" pattern="yyyy-MM-dd HH:mm:ss" />
                    </td>
                    <td align="center">
                        <!-- 删除按钮 -->
                        <form action="" method="post" style="display:inline;">
                            <input type="hidden" name="deleteId" value="<%= paymentId %>">
                            <button type="submit" class="layui-btn layui-btn-danger layui-btn-mini">删除</button>
                        </form>
                        <!-- 修改按钮 -->
                        <form action="edit_payment" method="post" style="display:inline;">
                            <input type="hidden" name="paymentId" value="<%= paymentId %>">
                            <button type="submit"  class="layui-btn layui-btn-normal layui-btn-mini">修改</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>
</body>
</html>
