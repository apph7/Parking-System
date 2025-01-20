<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*, java.util.*, java.io.InputStream" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Parking System</title>
  <script src="https://cdn.jsdelivr.net/npm/echarts@5.3.2/dist/echarts.min.js"></script>
</head>
<body>
<div style="width: 90%; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
  <div id="parkingSystem" style="width: 100%; height: 100px;"></div>
</div>
<script>
  var option = {
    graphic: {
      elements: [
        {
          type: 'text',
          left: 'center',
          top: 'center',
          style: {
            text: 'Parking System', // 显示 "Parking System"
            fontSize: 80,
            fontWeight: 'bold',
            lineDash: [0, 200],
            lineDashOffset: 0,
            fill: 'transparent',
            stroke: '#000',
            lineWidth: 1
          },
          keyframeAnimation: {
            duration: 2000,  // 动画时长设置为 2 秒
            loop: false,     // 动画只播放一次，完成后不再重复
            keyframes: [
              {
                percent: 0.7,
                style: {
                  fill: 'transparent',
                  lineDashOffset: 200,
                  lineDash: [200, 0]
                }
              },
              {
                // 停顿一会儿，透明填充
                percent: 0.8,
                style: {
                  fill: 'transparent'
                }
              },
              {
                percent: 1,
                style: {
                  fill: 'black'  // 最终文本变为黑色
                }
              }
            ]
          },
          animationDuration: 2000,  // 设置动画时长为 2 秒，之后保持不变
        }
      ]
    }
  };

  // 初始化 ECharts 实例并设置配置
  var chart = echarts.init(document.getElementById('parkingSystem'));
  chart.setOption(option);
</script>

</body>
</html>
