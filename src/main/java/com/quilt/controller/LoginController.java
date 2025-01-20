package com.quilt.controller;

import com.quilt.dto.Result;
import com.quilt.entity.Log;
import com.quilt.entity.User;
import com.quilt.exception.QuiltException;
import com.quilt.exception.enums.QuiltEnums;
import com.quilt.service.LogService;
import com.quilt.service.UserService;
import com.quilt.utils.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    UserService userService;

    @Autowired
    LogService logService;

    @RequestMapping("/login")
    public String getLoginPage(){
        return "home/login";
    }

    @RequestMapping("/admin")
    public String getadminPage(){
        return "home/admin";
    }
    //支付管理
    @RequestMapping("/payment")
    public String paymentPage(){
        return "admin/payment";
    }
    @RequestMapping("/edit_payment")
    public String edit_paymentPage(){
        return "admin/edit_payment";
    }

    @RequestMapping("/message")
    public String messagePage(){return "/common/message";}
    //用户管理
    @RequestMapping("/user_info")
    public String user_infoPage(){
        return "admin/user_info";
    }
    @RequestMapping("/edit_user")
    public String user_addPage(){
        return "admin/edit_user";
    }
    @RequestMapping("/edit_add_user")
    public String edit_add_userPage(){
        return "admin/edit_add_user";
    }
    //车辆管理
    @RequestMapping("/vehicles")
    public String vehiclesPage(){
        return "admin/vehicles";
    }
    @RequestMapping("/edit_vehicles")
    public String edit_vehiclesPage(){
        return "admin/edit_vehicles";
    }
    @RequestMapping("/edit_add_vehicles")
    public String edit_add_vehiclesPage(){
        return "admin/edit_add_vehicles";
    }
   //车位管理
   @RequestMapping("/showparking")
   public String showparkingPage(){
       return "admin/showparking";
   }
    @RequestMapping("/parking_spot")
    public String parking_spotPage(){
        return "admin/parking_spot";
    }
    @RequestMapping("/edit_spot")
    public String edit_spotPage(){
        return "admin/edit_spot";
    }
    @RequestMapping("/edit_add_spot")
    public String edit_add_spotPage(){
        return "admin/edit_add_spot";
    }
    @RequestMapping("/parking_record")
    public String parking_recordPage(){
        return "admin/parking_record";
    }
    @RequestMapping("/edit_record")
    public String edit_recordPage(){return "/admin/edit_record";}

    //公告管理
    @RequestMapping("/detail")
    public String detailPage(){return "/admin/detail";}
    @RequestMapping("/bulletin")
    public String bulletinPage(){return "/admin/bulletin";}
    @RequestMapping("/edit_bulletin")
    public String edit_bulletinPage(){return "/admin/edit_bulletin";}
    @RequestMapping("/edit_add_bulletin")
    public String edit_add_bulletinPage(){return "/admin/edit_add_bulletin";}


    //用户端
    @RequestMapping("/User/index")
    public String User_indexPage(){
        return "User/index";
    }
    @RequestMapping("/User/console")
    public String consolePage(){
        return "User/console";
    }
    @RequestMapping("/userspot")
    public String userspotPage(){
        return "User/parking_spot";
    }
    @RequestMapping("/userrecord")
    public String userrecordPage(){
        return "User/parking_record";
    }
    @RequestMapping("/userpayment")
    public String userpaymentPage(){
        return "User/payment";
    }
    @RequestMapping("/uservehicles")
    public String uservehiclesPage(){
        return "User/vehicles";
    }
    @RequestMapping("/account")
    public String useraccountPage(){return "User/account";}
    @RequestMapping("/spot_use")
    public String spot_usePage(){return "User/spot_use";}
    @RequestMapping("/recharge")
    public String rechargePage(){return "User/recharge";}

    @RequestMapping("/test")
    public String getLoginPage41(){
        return "home/test";
    }
    @RequestMapping("/index")
    public String getLoginPage42(){
        return "index";
    }
    @RequestMapping("/1")
    public String getLoginPage43(){
        return "1";
    }
    @RequestMapping("/map")
    public String getLoginPage25(){
        return "map";
    }

    @RequestMapping("/admin/check")
    @ResponseBody
    public Result loginCheck(HttpServletRequest servletRequest, HttpSession session, String username, String password){

        try {
            User user = userService.login(username, password);
            if (user == null) {
                Log log = new Log();
                log.setIp(WebUtils.getClientIp(servletRequest));
                log.setLogDetail("登录失败");
                log.setLogType("登录");
                logService.addLogRecord(log);

                return new Result(QuiltEnums.FAILED);


            } else {
                session.setAttribute("user", user);

                Log log = new Log();
                log.setIp(WebUtils.getClientIp(servletRequest));
                log.setLogDetail("登录成功");
                log.setLogType("登录");
                logService.addLogRecord(log);

                return new Result(QuiltEnums.SUCCESS);
            }
        }catch (QuiltException qe){
            return new Result(qe.getQuiltEnums());
        }

    }





}
