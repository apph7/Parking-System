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
    <title>用户登录</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery.js"></script>
    <script src="<%=request.getContextPath()%>/static/js/md5.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <%@ include file="../common/message.jsp" %>
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/static/logo.png">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/login/login.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/style/admin.css" media="all">
    <link href="//unpkg.com/layui@2.9.21/dist/css/layui.css" rel="stylesheet">
</head>
<body>


<div class="container">
    <!-- Sign Up -->
    <div class="container__form container--signup" >
        <form class="form" id="signupForm" method="post" action="login">
            <h2 class="form__title">Sign Up</h2>
            <input type="hidden" name="formType" value="signup">
            <input type="text" id="signUpUserName" name="userName" placeholder="User" class="input" />
            <input type="email" id="signUpEmail" name="email" placeholder="Email" class="input" />
            <input type="password" id="signUpUserPass" name="userPass" placeholder="Password" class="input" />
            <input style="text-align: center; bottom: 50px;" class="btn"  id="signUpBtn" type="submit" value="Sign Up">
        </form>
    </div>

    <!-- Sign In -->
    <div class="container__form container--signin">
        <form class="form" id="signinForm" method="post" action="login">
            <h2 class="form__title">Sign In</h2>
            <input type="hidden" name="formType" value="signin">
            <input  type="text" id="userName" name="username" placeholder="Username" class="input" />
            <input  type="password" id="userPass" name="password" placeholder="Password" class="input" />
            <input style="text-align: center; bottom: 50px;" class="btn"  id="signInBtn" type="submit" value="Sign In">
        </form>
    </div>

    <!-- Overlay -->
    <div class="container__overlay">
        <div class="overlay">
            <div class="overlay__panel overlay--left">
                <div style="text-align: center; margin-bottom:200px;">
                    <!-- 添加 Logo 图片 -->
                    <img src="<%=request.getContextPath()%>/static/logo.png" alt="Logo"
                         style="width: 70px; height: 70px; vertical-align: middle;">
                    <span style="font-size: 36px; font-weight: bold;
                         background: linear-gradient(to bottom, #ffffff, #d9d9d9);
                         -webkit-background-clip: text;
                         -webkit-text-fill-color: transparent;">
                Parking System
            </span>
                </div>
                <div style="text-align: center; position: absolute; bottom: 50px; width: 100%;">
                    <button class="btn" id="signInSwitch">Sign In</button>
                </div>
            </div>
            <div class="overlay__panel overlay--right">
                <div style="text-align: center; margin-bottom:200px;">
                    <!-- 添加 Logo 图片 -->
                    <img src="<%=request.getContextPath()%>/static/logo.png" alt="Logo"
                         style="width: 70px; height: 70px; vertical-align: middle;">
                    <span style="font-size: 36px; font-weight: bold;
                         background: linear-gradient(to bottom, #ffffff, #d9d9d9);
                         -webkit-background-clip: text;
                         -webkit-text-fill-color: transparent;">
                Parking System
            </span>
                </div>
                <div style="text-align: center; position: absolute; bottom: 50px; width: 100%;">
                    <button class="btn" id="signUpSwitch">Sign Up</button>
                </div>
            </div>
        </div>

    </div>
</div>


<script src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-md5/2.10.0/js/md5.min.js"></script>
<script>

    // 切换到登录
    $("#signInSwitch").on("click", function () {
        $(".container").removeClass("right-panel-active");
    });

    // 切换到注册
    $("#signUpSwitch").on("click", function () {
        $(".container").addClass("right-panel-active");
    });

</script>
</body>
</html>


<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String formType = request.getParameter("formType"); // 获取表单类型
        // 判断表单类型
        if ("signup".equals(formType)) {
            // 获取表单数据
            String username = request.getParameter("userName");
            String email = request.getParameter("email");
            String password = request.getParameter("userPass");
            // 检查用户名和密码是否为空
            if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                // 如果为空，返回提示错误
                request.getSession().setAttribute("message", "用户名或密码为空！");
                request.getSession().setAttribute("messageType", "error");
                return; // 提前返回，不继续执行后续代码
            }

            // 加载 jdbc.properties 配置文件
            Properties properties = new Properties();
            try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties")) {
                if (inputStream != null) {
                    properties.load(inputStream);

                    String dbUrl = properties.getProperty("url");
                    String dbUsername = properties.getProperty("user");
                    String dbPassword = properties.getProperty("password");
                    String dbDriver = properties.getProperty("driver");

                    try {
                        // 加载数据库驱动
                        Class.forName(dbDriver);
                        // 获取数据库连接
                        Connection connection = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

                        // 检查用户名或邮箱是否已存在
                        String checkQuery = "SELECT COUNT(*) FROM user WHERE username = ? OR user_email = ?";
                        try (PreparedStatement statement = connection.prepareStatement(checkQuery)) {
                            statement.setString(1, username);
                            statement.setString(2, email);

                            try (ResultSet resultSet = statement.executeQuery()) {
                                resultSet.next();
                                int count = resultSet.getInt(1);

                                if (count > 0) {
                                    request.getSession().setAttribute("message", "用户或邮箱已存在！");
                                    request.getSession().setAttribute("messageType", "error");

                                } else {
                                    // 插入新用户
                                    String insertQuery = "INSERT INTO user (username, user_email, password) VALUES (?, ?, ?)";
                                    try (PreparedStatement insertStatement = connection.prepareStatement(insertQuery)) {
                                        insertStatement.setString(1, username);
                                        insertStatement.setString(2, email);
                                        insertStatement.setString(3, password); // 密码应加密，但这里为简化示例

                                        int rowsInserted = insertStatement.executeUpdate();
                                        if (rowsInserted > 0) {
                                            request.getSession().setAttribute("message", "注册成功，欢迎您！");
                                            request.getSession().setAttribute("messageType", "success");
                                        } else {
                                            request.getSession().setAttribute("message", "注册失败，请重试！");
                                            request.getSession().setAttribute("messageType", "error");

                                        }
                                    }
                                }
                            }
                        }

                    } catch (Exception e) {
                        request.getSession().setAttribute("message", "注册失败，请重试！");
                        request.getSession().setAttribute("messageType", "error");
                    }
                } else {
                    request.getSession().setAttribute("message", "注册失败，请重试！");
                    request.getSession().setAttribute("messageType", "error");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("message", "注册失败，请重试！");
                request.getSession().setAttribute("messageType", "error");
            }

        } else if ("signin".equals(formType)) {

                // 获取登录表单数据
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                // 检查用户名和密码是否为空
                if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                    request.getSession().setAttribute("message", "用户名或密码不能为空！");
                    request.getSession().setAttribute("messageType", "error");
                    return;
                }

                // 加载 jdbc.properties 配置文件
                Properties properties = new Properties();
                try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties")) {
                    if (inputStream != null) {
                        properties.load(inputStream);

                        String dbUrl = properties.getProperty("url");
                        String dbUsername = properties.getProperty("user");
                        String dbPassword = properties.getProperty("password");
                        String dbDriver = properties.getProperty("driver");

                        try {
                            // 加载数据库驱动
                            Class.forName(dbDriver);
                            // 获取数据库连接
                            Connection connection = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);

                            // 查询用户表，验证用户名和密码
                            String query = "SELECT id,money FROM guest WHERE username = ? AND password = ?";
                            try (PreparedStatement statement = connection.prepareStatement(query)) {
                                statement.setString(1, username);
                                statement.setString(2, password);

                                try (ResultSet resultSet = statement.executeQuery()) {
                                    if (resultSet.next()) {
                                        request.getSession().setAttribute("message", "登录成功，欢迎您！");
                                        request.getSession().setAttribute("messageType", "success");
                                        int userid=resultSet.getInt("id");
                                        double money =resultSet.getDouble("money");
                                        session.setAttribute("username", username);
                                        session.setAttribute("userid", userid);
                                        session.setAttribute("money", money);
                                        System.out.println(userid);
                                        System.out.println(username);
                                        // 此处可进行跳转或设置 session，例如 session.setAttribute("user", username);
                                        response.sendRedirect("User/index");
                                    } else {
                                        // 登录失败，用户名或密码错误
                                        request.getSession().setAttribute("message", "用户名或密码错误！");
                                        request.getSession().setAttribute("messageType", "error");
                                    }

                                }
                            }

                        } catch (Exception e) {
                            out.println("<script>showErrorMessage('数据库连接失败，请稍后重试！');</script>");
                        }
                    } else {
                        out.println("<script>showErrorMessage('配置文件加载失败！');</script>");
                    }
                } catch (Exception e) {
                    out.println("<script>showErrorMessage('登录失败，请重试！');</script>");
                }
            }
    }
%>
