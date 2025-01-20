<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.io.InputStream" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>车辆类型占比</title>
    <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
    <script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
</head>
<body>
<div style="width: 80%; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
    <h2 style="text-align: center; font-size: 20px; color: #333; ">已登记车辆类型占比图</h2>
    <div id="main" style="width: 90%;height: 300px; margin: auto; margin-top: 30px;"></div>
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


    // 查询车辆类型统计信息
    Map<String, Integer> vehicleTypeCounts = new HashMap<>();
    String query = "SELECT vehicle_type, COUNT(*) AS count FROM vehicles GROUP BY vehicle_type";
    Class.forName(dbDriver);
    try (Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword);
         PreparedStatement pstmt = conn.prepareStatement(query);
         ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
            vehicleTypeCounts.put(rs.getString("vehicle_type"), rs.getInt("count"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    // 转换为 JSON 数据
    StringBuilder dataJson = new StringBuilder("[");
    for (Map.Entry<String, Integer> entry : vehicleTypeCounts.entrySet()) {
        dataJson.append("{ value: ").append(entry.getValue())
                .append(", name: '").append(entry.getKey()).append("' },");
    }
    if (dataJson.length() > 1) {
        dataJson.setLength(dataJson.length() - 1); // 移除最后一个逗号
    }
    dataJson.append("]");
%>

<script>
    var chartDom = document.getElementById('main');
    var myChart = echarts.init(chartDom);
    var option;

    // 使用 JSP 动态生成的 JSON 数据
    var data = <%= dataJson.toString() %>;

    option = {
        tooltip: {
            trigger: 'item'
        },
        legend: {
            top: '5%',
            left: 'center'
        },
        series: [
            {
                name: '车辆类型',
                type: 'pie',
                radius: ['40%', '70%'],
                center: ['50%', '50%'],
                data: data
            }
        ]
    };

    option && myChart.setOption(option);
</script>
</body>
</html>
