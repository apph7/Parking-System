
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

<head>

  <meta charset="utf-8">
  <title>用户端</title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport"
        content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/layui/css/layui.css" media="all">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/WEB-INF/jsp/common/iconfont.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/style/admin.css" media="all">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/static/font-awesome/css/font-awesome.css">
  <script src="<%=request.getContextPath()%>/static/editor/js/jquery.min.js"></script>
  <script src="<%=request.getContextPath()%>/static/layuiadmin/layui/layui.js"></script>
</head>
<style>
  cite{
    font-size: 18px; margin-left: 8px; font-family: 'Roboto Slab', serif; font-weight: 900; color: #FFFFFF; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);"
  }
  dd{
    margin-left: 20px;
  }
</style>
<body class="layui-layout-body">

<div id="LAY_app">
  <div class="layui-layout layui-layout-admin">
    <div class="layui-header">
      <!-- 头部区域 -->
      <ul class="layui-nav layui-layout-left">
        <li class="layui-nav-item layadmin-flexible" lay-unselect>
          <a href="javascript:;" layadmin-event="flexible" title="侧边伸缩">
            <i class="layui-icon layui-icon-shrink-right" id="LAY_app_flexible"></i>
          </a>
        </li>
        <li class="layui-nav-item" lay-unselect>
          <a href="javascript:;" layadmin-event="refresh" title="刷新">
            <i class="layui-icon layui-icon-refresh-3"></i>
          </a>
        </li>
        <!--
        <li class="layui-nav-item layui-hide-xs" lay-unselect>
            <input type="text" placeholder="搜索..." autocomplete="off" class="layui-input layui-input-search"
                   layadmin-event="serach" lay-action="/admin/search?q=">
        </li>-->
      </ul>
      <ul class="layui-nav layui-layout-right" lay-filter="layadmin-layout-right">
        <li class="layui-nav-item layui-hide-xs" lay-unselect>
          <a href="javascript:;" layadmin-event="theme">
            <i class="layui-icon layui-icon-theme"></i>
          </a>
        </li>
        <li class="layui-nav-item layui-hide-xs" lay-unselect>
          <a href="javascript:;" layadmin-event="note">
            <i class="layui-icon layui-icon-note"></i>
          </a>
        </li>
        <li class="layui-nav-item layui-hide-xs" lay-unselect>
          <a href="javascript:;" layadmin-event="fullscreen">
            <i class="layui-icon layui-icon-screen-full"></i>
          </a>
        </li>
        <!--这里-->
        <li class="layui-nav-item" lay-unselect>
          <a href="javascript:;">
            <img id="myImage" src="<%=request.getContextPath()%>/static/OIP.jpg" class="layui-nav-img">
            <cite>${user.username}</cite>
          </a>
          <dl class="layui-nav-child">
            <dd><a lay-href="<%=request.getContextPath()%>/account">基本资料</a></dd>
            <hr>
            <dd><a href="<%=request.getContextPath()%>/login">退出</a></dd>
          </dl>
        </li>
        <!--这里-->


        <li class="layui-nav-item layui-hide-xs" lay-unselect>
          <a href="javascript:;"><i class="layui-icon layui-icon-more-vertical"></i></a>
        </li>

      </ul>
    </div>

    <!-- 侧边菜单 -->
    <div class="layui-side layui-side-menu">
      <div class="layui-side-scroll">
        <div class="layui-logo" lay-href="console.jsp" style="display: flex; align-items: center;">
          <!-- 添加 Logo 图片 -->

          <span style="font-size: 18px; font-weight: bold; color: #fff;">
                         <img src="<%=request.getContextPath()%>/static/logo.png" alt="Logo" style="width: 30px; height: 30px; margin-right: 10px;">
                        Parking System</span>
        </div>


        <ul class="layui-nav layui-nav-tree" lay-shrink="all" id="LAY-system-side-menu"
            lay-filter="layadmin-system-side-menu" >
          <li data-name="home" class="layui-nav-item layui-nav-itemed">
            <a lay-href="<%=request.getContextPath()%>/User/console" lay-tips="主页" lay-direction="2">
              <i class="layui-icon layui-icon-home" ></i>
              <cite>主页</cite>
            </a>
          </li>

          <li data-name="component" class="layui-nav-item"> <!-- 不添加 layui-nav-itemed 类 -->
            <a href="javascript:;" lay-tips="车位" lay-direction="2">
              <i class="layui-icon layui-icon-survey"></i>
              <cite>车位管理</cite>
            </a>
            <dl class="layui-nav-child">
              <dd>
                <a lay-href="<%=request.getContextPath()%>/showparking">
                  <i class="layui-icon layui-icon-list"></i>
                  停车信息</a>
              </dd>
              <dd>
                <a lay-href="<%=request.getContextPath()%>/userspot">
                  <i class="layui-icon layui-icon-list"></i>
                  停车位</a>
              </dd>
              <dd>
                <a lay-href="<%=request.getContextPath()%>/userrecord">
                  <i class="layui-icon layui-icon-survey"></i>
                  停车记录</a>
              </dd>
            </dl>
          </li>

          <li data-name="component" class="layui-nav-item"> <!-- 不添加 layui-nav-itemed 类 -->
            <a href="javascript:;" lay-tips="财务管理" lay-direction="2">
              <i class="layui-icon layui-icon-rmb"></i>
              <cite>财务管理</cite>
            </a>
            <dl class="layui-nav-child">
              <dd data-name="carousel">
                <a lay-href="<%=request.getContextPath()%>/userpayment">
                  <i class="layui-icon layui-icon-chart-screen"></i>
                  支付账单</a>
              </dd>
            </dl>
          </li>

          <li data-name="app" class="layui-nav-item"> <!-- 不添加 layui-nav-itemed 类 -->
            <a href="javascript:;" lay-tips="车辆管理" lay-direction="2">
              <i class="layui-icon layui-icon-engine"></i>
              <cite>车辆管理</cite>
            </a>
            <dl class="layui-nav-child">
              <dd data-name="carousel">
                <a lay-href="<%=request.getContextPath()%>/uservehicles">
                  <i class="layui-icon layui-icon-engine"></i>
                  车辆信息</a>
              </dd>
            </dl>
          </li>

          <li data-name="user" class="layui-nav-item"> <!-- 不添加 layui-nav-itemed 类 -->
            <a lay-href="<%=request.getContextPath()%>/bulletin" lay-tips="公告" lay-direction="2">
              <i class="layui-icon layui-icon-layouts"></i>
              <cite>公告列表</cite>
            </a>
          </li>

          <li data-name="user" class="layui-nav-item"> <!-- 不添加 layui-nav-itemed 类 -->
            <a lay-href="<%=request.getContextPath()%>/account" lay-tips="用户" lay-direction="2">
              <i class="layui-icon layui-icon-user"></i>
              <cite>用户管理</cite>
            </a>
          </li>




        </ul>
      </div>
    </div>

    <!-- 页面标签 -->
    <div class="layadmin-pagetabs" id="LAY_app_tabs">
      <div class="layui-icon layadmin-tabs-control layui-icon-prev" layadmin-event="leftPage"></div>
      <div class="layui-icon layadmin-tabs-control layui-icon-next" layadmin-event="rightPage"></div>
      <div class="layui-icon layadmin-tabs-control layui-icon-down">
        <ul class="layui-nav layadmin-tabs-select" lay-filter="layadmin-pagetabs-nav">
          <li class="layui-nav-item" lay-unselect>
            <a href="javascript:;"></a>
            <dl class="layui-nav-child layui-anim-fadein">
              <dd layadmin-event="closeThisTabs"><a href="javascript:;">关闭当前标签页</a></dd>
              <dd layadmin-event="closeOtherTabs"><a href="javascript:;">关闭其它标签页</a></dd>
              <dd layadmin-event="closeAllTabs"><a href="javascript:;">关闭全部标签页</a></dd>
            </dl>
          </li>
        </ul>
      </div>
      <div class="layui-tab" lay-unauto lay-allowClose="true" lay-filter="layadmin-layout-tabs">
        <ul class="layui-tab-title" id="LAY_app_tabsheader">
          <li lay-id="console.jsp" lay-attr="console.jsp" class="layui-this"><i
                  class="layui-icon layui-icon-home"></i></li>
        </ul>
      </div>
    </div>


    <!-- 主体内容 -->
    <div class="layui-body" id="LAY_app_body">
      <div class="layadmin-tabsbody-item layui-show">
        <iframe src="console.html" frameborder="0" class="layadmin-iframe"></iframe>
      </div>
    </div>

    <!-- 辅助元素，一般用于移动设备下遮罩 -->
    <div class="layadmin-body-shade" layadmin-event="shade"></div>
  </div>
</div>

<script src="<%=request.getContextPath()%>/static/layuiadmin/layui/layui.js"></script>
<script>
  layui.config({
    base: '<%=request.getContextPath()%>/static/layuiadmin/' //静态资源所在路径
  }).extend({
    index: 'lib/index' //主入口模块
  }).use('index');
</script>
</body>

</html>

