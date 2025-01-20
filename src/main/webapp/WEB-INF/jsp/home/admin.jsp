
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.util.Properties, java.io.InputStream"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统登录</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/login/login.css">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery.js"></script>
    <script src="<%=request.getContextPath()%>/static/js/md5.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
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
</head>
<body>



<div class="container">
    <!-- Sign Up -->
    <div class="container__form container--signup" >
        <form class="form" id="signupForm" method="post" action="../admin">
            <h2 class="form__title">Sign Up</h2>
            <input type="text" id="signUpUserName" name="userName" placeholder="User" class="input" />
            <input type="email" id="signUpEmail" name="email" placeholder="Email" class="input" />
            <input type="password" id="signUpUserPass" name="userPass" placeholder="Password" class="input" />
            <input style="text-align: center; bottom: 50px;" class="btn" class="btn" id="signUpBtn" type="submit" value="Sign Up">
        </form>
    </div>

    <!-- Sign In -->
    <div class="container__form container--signin">
        <form class="form" id="signinForm">
            <h2 class="form__title">Sign In</h2>
            <input  type="text" id="userName" name="userName" placeholder="Username" class="input" />
            <input  type="password" id="userPass" name="userPass" placeholder="Password" class="input" />
            <button  style="text-align: center;  bottom: 50px;" class="btn" type="button" id="login">Sign In</button>
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


<div id="errorMessage" style="display: none; position: fixed; top: 20px; left: 50%; transform: translateX(-50%); padding: 10px 20px; background-color: #f8d7da; color: #842029; border: 1px solid #f5c2c7; border-radius: 5px; font-size: 14px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); z-index: 1000;">
    登录失败
</div>
<div id="successMessage" style="display: none; position: fixed; top: 20px; left: 50%; transform: translateX(-50%); padding: 10px 20px; background-color: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; border-radius: 5px; font-size: 14px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); z-index: 1000;">
    登录成功
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-md5/2.10.0/js/md5.min.js"></script>
<script>
    //md5加密
    document.getElementById("signupForm").onsubmit = function(event) {
        event.preventDefault();  // 防止表单默认提交
        // 获取用户输入的密码
        var password = document.getElementById("signUpUserPass").value;
        // 使用 MD5 对密码进行加密
        var hashedPassword = md5(password);
        // 修改表单中的密码字段为加密后的密码
        document.getElementById("signUpUserPass").value = hashedPassword;
        // 提交表单
        this.submit();
    };
    // 异步提交表单
    $(document).ready(
        $("#login").on("click", function() {
            // 检查用户名密码是否为空 密码MD5加密

            if ($("#userName").val() == "" || $('#userPass').val() == "") {
                const errorMessage = $("#errorMessage");
                errorMessage.text("登录失败，用户名或密码不能为空！").fadeIn();

                // 3秒后自动隐藏
                setTimeout(function () {
                    errorMessage.fadeOut();
                }, 3000);

            }
            else{
            var fd = new FormData();
            fd.append("username", $("#userName").val());
            fd.append("password", md5($('#userPass').val()));
            // alert(fd.get("password"))
            $.ajax({
                type: 'post',
                data:
                    {
                        username: $("#userName").val(),
                        password: md5($('#userPass').val())
                    },
                url: '<%=request.getContextPath()%>/admin/check',
                cache: false,
                dataType: 'text',
                success: function (data) {
                    var data1 = $.parseJSON(data);
                    if (data1.state == 0) {
                        const errorMessage = $("#errorMessage");
                        errorMessage.text("登录失败，用户名或密码错误！").fadeIn();

                        // 3秒后自动隐藏
                        setTimeout(function () {
                            errorMessage.fadeOut();
                        }, 3000);

                    } else {
                        const successMessage = $("#successMessage");
                        successMessage.text("登录成功，欢迎回来！").fadeIn();
                        setTimeout(function () {
                            successMessage.fadeOut();
                        }, 3000); // 3秒后隐藏成功提示
                        // 1 秒后跳转到目标页面
                        setTimeout(() => {
                            location.href = "<%=request.getContextPath()%>/admin/index";
                        }, 1000); // 1000 毫秒 = 1 秒
                    }
                }
            });
        }
        })
    );

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
        // 获取表单数据
        String username = request.getParameter("userName");
        String email = request.getParameter("email");
        String password = request.getParameter("userPass");
        // 检查用户名和密码是否为空
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            // 如果为空，返回提示错误
            out.println("<script>showErrorMessage('用户名或密码为空！');</script>");
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

                                out.println("<script>showErrorMessage('用户或邮箱已存在！');</script>");
                            } else {
                                // 插入新用户
                                String insertQuery = "INSERT INTO user (username, user_email, password) VALUES (?, ?, ?)";
                                try (PreparedStatement insertStatement = connection.prepareStatement(insertQuery)) {
                                    insertStatement.setString(1, username);
                                    insertStatement.setString(2, email);
                                    insertStatement.setString(3, password); // 密码应加密，但这里为简化示例

                                    int rowsInserted = insertStatement.executeUpdate();
                                    if (rowsInserted > 0) {
                                        out.println("<script>showSuccessMessage('注册成功，欢迎您！');</script>");
                                    } else {
                                        out.println("<script>showErrorMessage('注册失败，请重试！');</script>");
                                    }
                                }
                            }
                        }
                    }

                } catch (Exception e) {
                    out.println("<script>showErrorMessage('注册失败，请重试！');</script>");
                }
            } else {
                out.println("<script>showErrorMessage('注册失败，请重试！');</script>");
            }
        } catch (Exception e) {
            out.println("<script>showErrorMessage('注册失败，请重试！');</script>");
        }
    }
%>