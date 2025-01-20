<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>近一周停车数目统计</title>
  <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
  <script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
</head>
<body>
<div style="width: 80%; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
  <h2 style="text-align: center; font-size: 20px; color: #333;">近一周停车区域统计图</h2>
  <div id="main" style="width: 100%; height: 320px; margin-top: 10px;"></div>
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

  // 查询近一周每天各区域的停车数目统计
  Map<String, List<Integer>> parkingData = new HashMap<>();
  String query = "SELECT LEFT(ps.location, 1) AS zone, " +
          "DATE(pr.entry_time) AS day, COUNT(*) AS count " +
          "FROM parking_record pr " +
          "JOIN parking_spot ps ON pr.parking_spot_id = ps.id " +
          "WHERE pr.entry_time >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY) " +
          "AND ps.location LIKE 'A%' OR ps.location LIKE 'B%' OR ps.location LIKE 'C%' OR ps.location LIKE 'D%' " +
          "GROUP BY zone, day";

  // 初始化 Map
  for (String zone : Arrays.asList("A", "B", "C", "D")) {
    parkingData.put(zone, Arrays.asList(0, 0, 0, 0, 0, 0, 0)); // 默认7天全为0
  }

  Class.forName(dbDriver);
  try (Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword);
       PreparedStatement pstmt = conn.prepareStatement(query);
       ResultSet rs = pstmt.executeQuery()) {

    while (rs.next()) {
      String zone = rs.getString("zone");
      Date day = rs.getDate("day");
      int count = rs.getInt("count");

      // 根据日期更新统计结果
      Calendar cal = Calendar.getInstance();
      cal.setTime(day);
      int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK) - 1; // 星期天是0
      if (dayOfWeek == 0) dayOfWeek = 7; // 将星期天设置为7
      List<Integer> counts = parkingData.get(zone);
      counts.set(dayOfWeek - 1, count); // 更新对应日期的统计
    }
  } catch (SQLException e) {
    e.printStackTrace();
  }

  // 转换为 JSON 格式
  StringBuilder jsonBuilder = new StringBuilder("{");
  for (Map.Entry<String, List<Integer>> entry : parkingData.entrySet()) {
    jsonBuilder.append("'").append(entry.getKey()).append("': ").append(entry.getValue()).append(",");
  }
  if (jsonBuilder.length() > 1) {
    jsonBuilder.setLength(jsonBuilder.length() - 1); // 移除最后一个逗号
  }
  jsonBuilder.append("}");
%>

<script>
  var chartDom = document.getElementById('main');
  var myChart = echarts.init(chartDom);
  var option;

  // 使用 JSP 动态生成的 JSON 数据
  var rawData = <%= jsonBuilder.toString() %>;
  var days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // 构造 series 数据
  var series = [];
  for (var zone in rawData) {
    series.push({
      type: 'bar',
      data: rawData[zone],
      coordinateSystem: 'polar',
      name: zone,
      stack: 'a',
      emphasis: {
        focus: 'series'
      }
    });
  }

  option = {
    angleAxis: {
      type: 'category',
      data: days,
      boundaryGap: false
    },
    radiusAxis: {},
    polar: {},
    series: series,
    legend: {
      show: true,
      data: Object.keys(rawData),
      top: '0%', // 调整图例位置到底部
      left: 'center', // 居中显示
      itemGap: 20, // 增加图例项之间的间隔
      padding: [5, 0, 0, 0] // 减少顶部和标题间距
    },
    tooltip: {
      trigger: 'item'
    }
  };

  option && myChart.setOption(option);
</script>
</body>
</html>
