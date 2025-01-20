package com.quilt.service;

import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.sql.*;

@WebServlet("/displayImage")
public class DisplayImageServlet extends HttpServlet {

    protected void doPost(@RequestParam("photo_name") String photoName, @RequestParam("user") String user, HttpServletResponse response) throws ServletException, IOException {

        // 数据库连接
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 设置数据库连接（请确保使用实际的数据库信息）
            String dbUrl = "jdbc:mysql://localhost:3306/parking";
            String dbUser = "root";
            String dbPassword = "SGMsgm4610";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // 查询数据库中图片的二进制数据
            String sql = "SELECT photo_pic FROM photo WHERE photo_name = ? AND user = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, photoName);
            pstmt.setString(2, user);
            rs = pstmt.executeQuery();

            // 如果找到图片
            if (rs.next()) {
                // 获取图片的二进制数据
                InputStream inputStream = rs.getBinaryStream("photo_pic");

                // 设置响应的内容类型为图片格式（假设是 PNG）
                response.setContentType("image/png");

                // 将图片数据写入响应输出流
                OutputStream outStream = response.getOutputStream();
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outStream.write(buffer, 0, bytesRead);
                }

                // 关闭流
                inputStream.close();
                outStream.close();
            } else {
                // 如果没有找到图片，返回提示信息
                response.getWriter().println("<h3>Image not found for the specified user and photo name.</h3>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
