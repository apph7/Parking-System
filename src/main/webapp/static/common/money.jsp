<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.io.InputStream" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>最近收入</title>
  <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
  <script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
</head>
<body>
<div style="width: 90%; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
  <h2 style="text-align: center; font-size: 20px; color: #333; ">近一周每日收入统计</h2>
  <div id="main" style="width: 100%;height: 300px; margin: auto; margin-top: 30px;"></div>
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

  // Declare resources outside try block for cleanup later
  Connection conn = null;
  Statement stmt = null;
  ResultSet resultSet = null;

  List<String> dates = new ArrayList<>();
  Map<String, List<Double>> paymentData = new HashMap<>();
  paymentData.put("CASH", new ArrayList<Double>());
  paymentData.put("CARD", new ArrayList<Double>());
  paymentData.put("MOBILE", new ArrayList<Double>());


  try {
    // 连接数据库
    Class.forName(dbDriver);
    conn = DriverManager.getConnection(url, dbUsername, dbPassword);

    // 查询最近一周每日收入，按支付方式分组
    String query = "SELECT DATE(payment_time) AS date, payment_method, SUM(amount) AS total_amount " +
            "FROM payment " +
            "WHERE payment_time >= NOW() - INTERVAL 7 DAY " +
            "GROUP BY DATE(payment_time), payment_method " +
            "ORDER BY DATE(payment_time)";
    stmt = conn.createStatement();
    resultSet = stmt.executeQuery(query);

    // 存储查询结果
    while (resultSet.next()) {
      String date = resultSet.getString("date");
      String paymentMethod = resultSet.getString("payment_method");
      Double totalAmount = resultSet.getDouble("total_amount");

      // 如果日期是第一次出现，初始化所有支付方式的收入为 0
      if (!dates.contains(date)) {
        dates.add(date);
        paymentData.get("CASH").add(0.0);
        paymentData.get("CARD").add(0.0);
        paymentData.get("MOBILE").add(0.0);
      }

      // 根据支付方式更新收入数据
      int index = dates.indexOf(date);
      paymentData.get(paymentMethod).set(index, totalAmount);
    }
  } catch (Exception e) {
    e.printStackTrace();
  } finally {
    // 关闭资源
    try {
      if (resultSet != null && !resultSet.isClosed()) resultSet.close();
      if (stmt != null && !stmt.isClosed()) stmt.close();
      if (conn != null && !conn.isClosed()) conn.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }
%>
<script type="text/javascript">
  var dates = <%= new com.google.gson.Gson().toJson(dates) %>;
  var cashData = <%= new com.google.gson.Gson().toJson(paymentData.get("CASH")) %>;
  var cardData = <%= new com.google.gson.Gson().toJson(paymentData.get("CARD")) %>;
  var mobileData = <%= new com.google.gson.Gson().toJson(paymentData.get("MOBILE")) %>;

  // 计算总收入
  var totalIncome = dates.map((_, index) => {
    var cash = cashData[index] || 0;
    var card = cardData[index] || 0;
    var mobile = mobileData[index] || 0;
    return cash + card + mobile;
  });

  // 初始化 ECharts 实例
  var myChart = echarts.init(document.getElementById('main'));

  // 配置图表
  var option = {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    legend: {
      data: ['CASH', 'CARD', 'MOBILE', '总收入']
    },
    xAxis: {
      type: 'category',
      data: dates,
      axisLabel: {
        formatter: function (value) {
          return value; // 日期格式
        }
      }
    },
    yAxis: {
      type: 'value',
      name: '收入 (元)',
      axisLabel: {
        formatter: '{value} 元'
      }
    },
    series: [
      {
        name: 'CASH',
        type: 'bar',
        stack: '总收入',
        data: cashData,
        label: {
          show: true,
          position: 'inside',
          formatter: '{c} 元'
        }
      },
      {
        name: 'CARD',
        type: 'bar',
        stack: '总收入',
        data: cardData,
        label: {
          show: true,
          position: 'inside',
          formatter: '{c} 元'
        }
      },
      {
        name: 'MOBILE',
        type: 'bar',
        stack: '总收入',
        data: mobileData,
        label: {
          show: true,
          position: 'inside',
          formatter: '{c} 元'
        }
      },
      {
        name: '总收入',
        type: 'line',
        data: totalIncome,
        smooth: true, // 平滑曲线
        label: {
          show: true,
          position: 'top',
          formatter: '{c} 元'
        },
        lineStyle: {
          width: 2,
          color: '#EE6666'
        },
        itemStyle: {
          color: '#EE6666'
        }
      }
    ]
  };

  // 使用配置项填充图表
  myChart.setOption(option);
</script>

</body>
</html>
