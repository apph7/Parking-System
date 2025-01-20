<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Properties" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>今日登录统计</title>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
</head>
<body>
<div style="width: 100%; height: 400px; margin: auto; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); display: flex; justify-content: center; align-items: center;">

    <div id="gauge" style="width: 100%; height:100%;">网站登录次数</div>
</div>
<%
    // 加载 jdbc.properties 配置文件
    Properties properties = new Properties();
    InputStream inputStream = getClass().getClassLoader().getResourceAsStream("jdbc.properties");
    properties.load(inputStream);

    String url = properties.getProperty("url");
    String dbUsername = properties.getProperty("user");
    String dbPassword = properties.getProperty("password");
    String dbDriver = properties.getProperty("driver");

    int loginCount = 0; // 保存今日登录次数

    Class.forName(dbDriver);
    try (Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword)) {
        // 查询今日登录次数
        String loginQuery = "SELECT COUNT(*) AS login_count FROM log WHERE DATE(create_time) = CURRENT_DATE";
        try (PreparedStatement pstmt = conn.prepareStatement(loginQuery);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                loginCount = rs.getInt("login_count");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    // 计算仪表盘最大值 (动态设置登录上限)
    int maxLoginCount = (int) (Math.ceil((loginCount+100) / 100.0)+1) * 100;
    if (maxLoginCount == 0) maxLoginCount = 100; // 设置默认最大值为100
%>
<script>
    var chartDom = document.getElementById('gauge');
    var myChart = echarts.init(chartDom);

    // 动态设置最大值和当前登录次数
    var maxLoginCount = <%= maxLoginCount %>; // 最大登录次数
    var loginCount = <%= loginCount %>;      // 当前登录次数

    // 配置仪表盘
    var option = {
        tooltip: {
            formatter: '{a} <br/>{b} : {c} 次' // 显示提示信息
        },
        series: [
            {
                name: '登录统计', // 图表名称
                type: 'gauge',
                progress: {
                    show: true, // 显示进度条
                    width: 10   // 调整进度条宽度
                },
                detail: {
                    valueAnimation: true, // 显示动态变化
                    formatter: '{value} 次', // 显示单位
                    fontSize: 20           // 字体大小
                },
                axisLine: {
                    lineStyle: {
                        width: 15, // 调整轴线宽度
                        color: [
                            [0.25, '#7CFFB2'], // 绿色
                            [0.5, '#58D9F9'],  // 黄色
                            [0.75, '#FDDD60'], // 蓝色
                            [1, '#FF6E76']     // hongse
                        ]
                    }
                },
                pointer: {
                    width: 5 // 调整指针宽度
                },
                data: [
                    {
                        value: loginCount, // 动态插入登录次数
                        name: '今日登录'   // 数据名称
                    }
                ]
            }
        ]
    };

    // 渲染图表
    myChart.setOption(option);
</script>



</body>
</html>
