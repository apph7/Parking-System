package com.quilt.controller.admin;
import com.quilt.dto.Result;
import com.quilt.entity.User;
import com.quilt.entity.Visitor;
import com.quilt.exception.enums.QuiltEnums;
import com.quilt.service.VisitorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin/visitor")
public class VistitorController {

    @Autowired
    VisitorService visitorService;

    /**
     * 渲染访客记录页面
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("/index")
    public String getVisitorPage(HttpSession session, Model model){

        User user = (User) session.getAttribute("user");
        if(user == null){

            return "redirect:/login";
        }

        List<Visitor> visitorList = visitorService.getAllVisitorRecord();
        model.addAttribute("visitorList",visitorList);

        return "admin/visitor";
    }


    @RequestMapping("/delete/{id}")
    @ResponseBody
    public Result deleteVisitorRecord(HttpSession session,
                                      @PathVariable("id")Integer id){

        User user = (User) session.getAttribute("user");
        if(user == null){
            return new Result(QuiltEnums.FAILED);
        }

       // int r = logService.deleteLogRecrd(id);
        int r= visitorService.deleteVisitorRecord(id);

        if(r==1){

            return new Result(QuiltEnums.SUCCESS);
        }

        return new Result(QuiltEnums.FAILED);
    }


}
