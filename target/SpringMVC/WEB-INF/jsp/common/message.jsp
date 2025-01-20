<%--
  Created by IntelliJ IDEA.
  User: 梦一场
  Date: 2025/1/12
  Time: 15:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
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
  $(document).ready(function () {
      const reload = "<%= session.getAttribute("reload") %>";

      if (reload  === "true") {
          location.reload();
      }
      // 清除 session 中的提示信息
      <% session.removeAttribute("reload"); %>
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
</body>
</html>
