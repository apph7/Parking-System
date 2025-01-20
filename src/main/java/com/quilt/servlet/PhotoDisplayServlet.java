package com.quilt.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

public class PhotoDisplayServlet extends HttpServlet {
    protected void doGet(@org.jetbrains.annotations.NotNull HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 从请求中获取图片的 ID 或其他参数
        String id = request.getParameter("id");
        System.out.println("id = "+id);
        // 数据库连接
        String jdbcURL = "jdbc:mysql://localhost:3306/parking";
        String dbUser = "root";
        String dbPassword = "SGMsgm4610";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        try (Connection connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword)) {
            String sql = "SELECT photo FROM vehicles WHERE id = ?";

            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, id); // Replace with actual user identifier (e.g., userId)

                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    // Get the image binary data
                    InputStream photoStream = rs.getBinaryStream("photo");

                    // Set response type for images (you may change this based on your actual format)
                    response.setContentType("image/jpeg");

                    // Output the image data
                    OutputStream out = response.getOutputStream();
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = photoStream.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                    photoStream.close(); // Close the input stream after processing each image
                }
            } catch (SQLException | IOException e) {
                // Handle exceptions (e.g., database connection errors, IO errors)
                e.printStackTrace();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
