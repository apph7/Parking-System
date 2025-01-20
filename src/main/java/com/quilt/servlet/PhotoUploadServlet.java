package com.quilt.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.List;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.*;
import org.apache.commons.fileupload.servlet.*;

public class PhotoUploadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        // 设置上传的最大文件大小（例如 10MB）
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(1024 * 1024); // 1MB 缓存大小

        // 创建上传处理器
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setFileSizeMax(10 * 1024 * 1024); // 最大文件大小 10MB
        upload.setSizeMax(20 * 1024 * 1024); // 最大请求大小 20MB

        String jdbcURL = "jdbc:mysql://localhost:3306/parking";
        String dbUser = "root";
        String dbPassword = "SGMsgm4610";

        Connection connection = null;
        PreparedStatement stmt = null;

        try {
            // 解析请求
            List<FileItem> items = upload.parseRequest(request);

            String id = null;
            String licensePlate = null;
            String vehicleType = null;
            String ownerName = null;
            InputStream photoStream = null;

            // 处理表单数据和文件
            for (FileItem item : items) {
                if (item.isFormField()) {
                    switch (item.getFieldName()) {
                        case "id":
                            id = item.getString();
                            break;
                        case "licensePlate":
                            licensePlate = item.getString("UTF-8");
                            break;
                        case "vehicleType":
                            vehicleType = item.getString("UTF-8");
                            break;
                        case "ownerName":
                            ownerName = item.getString("UTF-8");
                            break;
                    }
                } else if ("photo".equals(item.getFieldName())) {
                    photoStream = item.getInputStream(); // 获取上传的图片流
                }
            }


            // 连接数据库
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // 更新车辆信息
            if (photoStream != null) {
                    String sql = "UPDATE vehicles SET license_plate = ?, vehicle_type = ?, owner_name = ?, photo = ? WHERE id = ?";
                    stmt = connection.prepareStatement(sql);
                    stmt.setString(1, licensePlate);
                    stmt.setString(2, vehicleType);
                    stmt.setString(3, ownerName);
                    stmt.setBinaryStream(4, photoStream); // 设置图片流
            } else {
                    String sql = "UPDATE vehicles SET license_plate = ?, vehicle_type = ?, owner_name = ? WHERE id = ?";
                    stmt = connection.prepareStatement(sql);
                    stmt.setString(1, licensePlate);
                    stmt.setString(2, vehicleType);
                    stmt.setString(3, ownerName);
            }
            stmt.setInt(5, Integer.parseInt(id));

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                // 更新成功，设置成功消息，并跳转回原界面
                request.getSession().setAttribute("message", "车辆信息更新成功！");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "车辆信息更新失败，请检查用户 ID 是否正确！");
                request.getSession().setAttribute("messageType", "error");
            }

            HttpSession session = request.getSession(false); // 获取当前会话，如果没有会话则返回 null
            Integer userId = (Integer) session.getAttribute("userid");
            if (userId != null) {
                response.sendRedirect("uservehicles");
            }else{
                response.sendRedirect("vehicles");
            }

        } catch (FileUploadException e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "文件上传错误");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect("edit_vehicles");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("数据库错误: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("发生意外错误: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
