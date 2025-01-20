<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.Properties, java.io.InputStream, java.io.IOException" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>添加车辆信息</title>
  <link rel="stylesheet" href="//unpkg.com/layui@2.9.21/dist/css/layui.css">
  <%@ include file="../common/message.jsp" %>
</head>
<body style="margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f5f5f5;">
<div style="width: 500px; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
  <fieldset style="margin-bottom: 20px; border: none;">
    <legend style="font-size: 20px; font-weight: bold; text-align: center;">添加车辆信息</legend>
  </fieldset>

  <form method="post" class="layui-form" style="margin-top: 20px;" action="addPhoto" enctype="multipart/form-data">

    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">车牌号</label>
      <div class="layui-input-inline" style="width: 300px;">
        <input type="text" name="licensePlate"  lay-verify="required" class="layui-input">
      </div>
    </div>

    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">车辆类型</label>
      <div class="layui-input-inline" style="width: 300px;">
        <select name="vehicleType" class="layui-input">
          <option value="CAR" >轿车</option>
          <option value="SUV" >SUV</option>
          <option value="TRUCK">卡车</option>
        </select>
      </div>
    </div>

    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px;">车主姓名</label>
      <div class="layui-input-inline" style="width: 300px;">
        <input type="text" name="ownerName"  class="layui-input">
      </div>
    </div>


    <div class="layui-form-item">
      <label class="layui-form-label" style="width: 100px; font-weight: bold; color: #333;">车辆图片</label>
      <div class="layui-input-inline" style="width: 300px; position: relative;">
        <input type="file" id="photo" name="photo" accept="image/*" class="layui-input" style="padding: 8px 12px; border: 1px solid #ccc; border-radius: 4px; background-color: #f9f9f9; color: #333; cursor: pointer;">
        <span style="position: absolute; top: 50%; right: 12px; transform: translateY(-50%); font-size: 14px; color: #999;">上传</span>
      </div>
    </div>


    <div class="layui-form-item">
      <div style="text-align: center;">
        <button type="submit" class="layui-btn">添加</button>
      </div>
    </div>
  </form>
</div>

<script src="//unpkg.com/layui@2.9.21/dist/layui.js"></script>
<script>
  layui.use('form', function(){
    var form = layui.form;
    form.verify({
      required: function(value){
        if(!value){
          return '此项不能为空';
        }
      }
    });
  });
</script>
</body>
</html>
