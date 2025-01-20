
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <title>Blog后台</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/layuiadmin/style/admin.css" media="all">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/css/style.css" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/static/editor/css/editormd.css" />
</head>

<body>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <fieldset class="layui-elem-field layui-field-title">
            <legend>上传相册</legend>
        </fieldset>
        <div class="layui-col-sm12">
            <div class="layui-card">
                <div class="layui-row layui-col-space15">
                    <div class="layui-col-sm9" style="margin-left:2.3rem">
                        <div class="layui-card-body layui-text">
                            <div class="layui-form-item">
                                <form class="layui-form" id="myForm" method="POST" enctype="multipart/form-data">
                                    <div class="layui-col-md9">
                                        <input type="hidden" name="userId" value="1">
                                        <div class="layui-form-item">
                                            <div style="position:relative;left:70px">
                                                <img class="layui-upload-img" src="<%=request.getContextPath()%>/static/pic/comment/default.jpg"
                                                     id="prevView" width="100" height="100">
                                                <input type="file" name="photoPic" class="input-avatar"
                                                       onchange="prev(this)" />
                                                &nbsp; &nbsp;
                                                <div class="layui-btn" onchange="prev(this)">上传图片</div>
                                            </div>
                                            <p id="demoText"></p>
                                        </div>

                                        <div class="layui-input-block">
                                            图片名称
                                            <input type="text" name="photoName" value=""
                                                   placeholder="请输入图片名称" autocomplete="off" class="layui-input">
                                        </div>
                                        <br>
                                        <div class="layui-input-block">
                                            <button class="layui-btn" id="save" data-type="insert"
                                                    type="button">保存</button>
                                        </div>
                                        <br>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<script src="<%=request.getContextPath()%>/static/editor/js/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/static/layuiadmin/layui/layui.js"></script>
<script>
    layui.config({
        base: '<%=request.getContextPath()%>/static/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'useradmin', 'table'], function () {
        var $ = layui.$,
            form = layui.form,
            table = layui.table;
    });
</script>

<script src="<%=request.getContextPath()%>/static/editor/editormd.js"></script>
<script type="text/javascript">
    $(function () {
        var testEditor = editormd("test-editormd", {
            width: "100%",
            height: 400,
            markdown: "",
            path: '<%=request.getContextPath()%>/static/editor/lib/',
            syncScrolling: "single",
            emoji: true,
            saveHTMLToTextarea: true,
            tocm: true, // Using [TOCM]
            tex: true, // 开启科学公式TeX语言支持，默认关闭
            flowChart: true, // 开启流程图支持，默认关闭
            /* 上传图片配置 */
            imageUpload: true,
            imageFormats: ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
            imageUploadURL: "<%=request.getContextPath()%>/admin/file/upload", //注意你后端的上传图片服务地址
        });
    });
</script>
<script type="text/javascript">
    function prev(event) {
        var img = document.getElementById("prevView");
        //获取文件对象
        let file = event.files[0];
        //获取文件阅读器
        let reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = function () {
            //给img的src设置图片url
            img.setAttribute("src", this.result);
            //alert(this.result);
        }


    }
    $("#save").on('click', function () {
        var your_photo_name = $('input[name="photoName"]').val();
        var your_photo_file = $('input[name="photoPic"]')[0].files[0];
        console.log(your_photo_file);
        var formData = new FormData(); // 创建一个 FormData 对象
        formData.append('photoName', your_photo_name);
        formData.append('photoPic', your_photo_file);

        $.ajax({
            type: "POST",
            url: '<%=request.getContextPath()%>/admin/photos/info/add',
            data: formData,
            cache: false,
            async: false,
            processData: false,
            contentType: false,
            dataType: "json",
            success: function (data) {
                if (data.state == 1) {
                    layer.alert("上传成功", { icon: 1 },function (index,item) {
                        location.reload();
                    });

                } else
                    layer.alert("上传失败", {icon: 5});
            }
        });
    });
</script>
</body>

</html>