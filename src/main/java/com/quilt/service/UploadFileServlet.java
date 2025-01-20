package com.quilt.service;


import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.InputStream;
import java.io.IOException;
import java.sql.*;

@MultipartConfig
public class UploadFileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String photoName = request.getParameter("photo_name");
        String user = request.getParameter("user");

        // 获取上传的文件
        Part filePart = request.getPart("file");
        InputStream fileContent = filePart.getInputStream();

        // 数据库连接
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 设置数据库连接（请确保使用实际的数据库信息）
            String dbUrl = "jdbc:mysql://localhost:3306/parking";
            String dbUser = "root";
            String dbPassword = "SGMsgm4610";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // SQL 查询，插入图片信息
            String sql = "INSERT INTO photo (photo_name, photo_pic, user) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, photoName);
            pstmt.setBinaryStream(2, fileContent);  // 将文件内容存储为 BLOB
            pstmt.setString(3, user);

            // 执行 SQL
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                response.getWriter().println("<h3>File uploaded successfully!</h3>");
            } else {
                response.getWriter().println("<h3>Failed to upload the file.</h3>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
