package com.quilt.utils;

import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

/**
 * 文件上传
 */
public class FileUploadUtil {

    private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd/");

    public static String saveImage(HttpSession session, MultipartFile file) throws IOException {

        // 指定文件路径
        String path = "/static/upload/" +dateFormat.format(new Date());
      //  String path = "C:/Users/hannah/Desktop/Quilt_Blog/src/main/webapp/static/upload/" + dateFormat.format(new Date());
        String realPath = session.getServletContext().getRealPath(path);

        // 指定保存文件名
        String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();
        //String fileName = file.getOriginalFilename();
        File saveFile = new File(realPath,fileName);

        if (!saveFile.getParentFile().exists()){

            saveFile.getParentFile().mkdirs();
        }

        //完成文件上传到指定位置
        file.transferTo(saveFile);

        return path + fileName ;

    }

    public static String saveHeadPic(HttpSession session, MultipartFile file) throws IOException {

        // 指定文件路径
      String path = "/static/images/headPic/" +dateFormat.format(new Date());
      //  String path = "C:/Users/hannah/Desktop/Quilt_Blog/src/main/webapp/static/images/headPic/" + dateFormat.format(new Date());

        String realPath = session.getServletContext().getRealPath(path);
        //String realPath = session.getServletContext().getRealPath("").toString();
        //System.out.println(realPath);
        // 指定保存文件名
        String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();

        File saveFile = new File(realPath,fileName);

        if (!saveFile.getParentFile().exists()){

            saveFile.getParentFile().mkdirs();
        }

        file.transferTo(saveFile);

        return path + fileName ;

    }

    public static String saveBgPic(HttpSession session, MultipartFile file) throws IOException {

        // 指定文件路径
       String path = "/static/images/bgPic/" +dateFormat.format(new Date());
       // String path = "C:/Users/hannah/Desktop/Quilt_Blog/src/main/webapp/static/images/bgPic/" + dateFormat.format(new Date());
        String realPath = session.getServletContext().getRealPath(path);

        // 指定保存文件名
        String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();

        File saveFile = new File(realPath,fileName);

        if (!saveFile.getParentFile().exists()){

            saveFile.getParentFile().mkdirs();
        }

        file.transferTo(saveFile);

        return path + fileName ;

    }

}
