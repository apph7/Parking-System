<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*, java.util.*, java.io.InputStream" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>车辆分布省份饼图</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.3.2/dist/echarts.min.js"></script>

</head>
<body>
<div style="width: 80%; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
    <div id="vehicleDistribution" style="width: 100%; height: 330px; margin-top: 10px;"></div>
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

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    List<Map<String, Object>> vehicleData = new ArrayList<>();

    try {
        // 1. 加载数据库驱动
        Class.forName(dbDriver);

        // 2. 建立连接
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // 3. 创建 SQL 查询语句
        String sql = "SELECT * FROM vehicles ";


        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        // 4. 处理查询结果并存储到 vehicleData 列表中
        Map<String, Integer> provinceCountMap = new HashMap<>();
        while (rs.next()) {
            String licensePlate = rs.getString("license_plate");
            String provinceCode = licensePlate.substring(0,1); // 获取车牌号的前两位（省份代码）
            System.out.println(provinceCode);
            // 使用 if 判断映射车牌号前两位为省份
            String province = null;
            if ("京".equals(provinceCode)) {
                province = "北京";
            } else if ("沪".equals(provinceCode)) {
                province = "上海";
            } else if ("粤".equals(provinceCode)) {
                province = "广东";
            } else if ("苏".equals(provinceCode)) {
                province = "江苏";
            } else if ("浙".equals(provinceCode)) {
                province = "浙江";
            } else if ("皖".equals(provinceCode)) {
                province = "安徽";
            } else if ("鲁".equals(provinceCode)) {
                province = "山东";
            } else if ("鄂".equals(provinceCode)) {
                province = "湖北";
            } else if ("豫".equals(provinceCode)) {
                province = "河南";
            } else if ("川".equals(provinceCode)) {
                province = "四川";
            } else if ("京".equals(provinceCode)) {
                province = "天津";
            } else if ("闽".equals(provinceCode)) {
                province = "福建";
            } else if ("湘".equals(provinceCode)) {
                province = "湖南";
            } else if ("陕".equals(provinceCode)) {
                province = "陕西";
            } else if ("吉".equals(provinceCode)) {
                province = "吉林";
            } else if ("黑".equals(provinceCode)) {
                province = "黑龙江";
            } else if ("甘".equals(provinceCode)) {
                province = "甘肃";
            } else if ("冀".equals(provinceCode)) {
                province = "河北";
            } else if ("辽".equals(provinceCode)) {
                province = "辽宁";
            } else if ("青".equals(provinceCode)) {
                province = "青海";
            } else {
                province = "未知"; // 如果不匹配任何省份，标记为“未知”
            }

            // 统计省份车辆数量
            provinceCountMap.put(province, provinceCountMap.getOrDefault(province, 0) + 1);
        }

        // 将结果转换为车辆分布数据
        for (Map.Entry<String, Integer> entry : provinceCountMap.entrySet()) {
            Map<String, Object> data = new HashMap<>();
            data.put("province", entry.getKey());
            data.put("vehicle_count", entry.getValue());
            vehicleData.add(data);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>


<script>
    // 从后端传递的 vehicleData 数据，模拟的格式 [{province: '山东', vehicle_count: 2}, ...]
    var vehicleData = <%= new com.google.gson.Gson().toJson(vehicleData) %>;

    // 创建数据数组，假设每个省份有一个车辆数量值
    const data = vehicleData.map(function(item) {
        return item.vehicle_count; // 仅获取车辆数量
    });

    // 各省的名称（可根据实际数据修改）
    const cities = vehicleData.map(function(item) {
        return item.province;
    });

    const option = {
        title: {
            text: '基于车辆注册数据',
            left: 'center'
        },
        legend: {
            show: false, // 不需要图例
        },
        grid: {
            top: 100
        },
        angleAxis: {
            type: 'category',
            data: cities
        },
        tooltip: {
            show: true,
            formatter: function (params) {
                const id = params.dataIndex;
                return (
                    cities[id] +
                    '<br>Vehicle Count：' +
                    data[id] + ' 辆' // 车辆数量（with "辆" unit）
                );
            }
        },
        radiusAxis: {
            min: 0,
            max: 20, // Maximum value for the radius axis
        },
        polar: {},
        series: [
            {
                // White bar covering half the height (creates the hollow effect)
                type: 'bar',
                itemStyle: {
                    color: 'White' // White color to simulate hollow center
                },
                data: data.map(function (d) {
                    return {
                        value: d / 2, // Half the height for the hollow effect
                        itemStyle: {
                            normal: {
                                color: 'White' // Set the color to white to simulate hollow
                            }
                        }
                    };
                }),
                coordinateSystem: 'polar',
                stack: 'Vehicles', // Stack to create bars
                silent: true,
                radiusAxisIndex: 0, // Reference to the radius axis
                barGap: '-100%',
            },
            {
                // Outer solid bar (Full height)
                type: 'bar',
                itemStyle: {
                    color: 'RoyalBlue' // Outer bar color
                },
                data: data.map(function (d) {
                    return {
                        value: d,
                        itemStyle: {
                            normal: {
                                color: 'RoyalBlue' // Outer part color
                            }
                        }
                    };
                }),
                coordinateSystem: 'polar',
                stack: 'Vehicles', // Stack to create bars
                silent: true,
                radiusAxisIndex: 0, // Reference to the radius axis
                barGap: '-100%',
            }
        ]
    };

    // 初始化 ECharts 实例并渲染
    var chart = echarts.init(document.getElementById('vehicleDistribution'));
    chart.setOption(option);
</script>

</body>
</html>
