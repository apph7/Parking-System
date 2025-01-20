//  ================ 浏览器图标 ====================
let favicon2 = document.createElement('link');
favicon2.rel = 'icon';
favicon2.href = '<%=request.getContextPath()%>/static/achievement/img/smallLogo.png';
document.head.appendChild(favicon2);

// ======================= screen slide ===================

//get slide_arrary 
const slide = document.querySelectorAll('.slide')
//get button prev
const prev = document.querySelector('#prev')
//get button next
const next = document.querySelector("#next")
 
const nextSlide = ()=>{
    const current = document.querySelector(".current")
    // 如果有下一个兄弟元素，就添加一个current 样式
    if(current.nextElementSibling){
        current.nextElementSibling.classList.add('current')
    }else{
        // 给最开始的添加current 样式
        slide[0].classList.add('current')
    }
    // 清除当前current 样式
    setTimeout(()=>{
        current.classList.remove('current')
    })
}
// 
const prevSlide = ()=>{
    const current = document.querySelector(".current")
    // 如果有上一个兄弟元素，就添加一个current 样式
    if(current.previousElementSibling){
        current.previousElementSibling.classList.add('current')
    }else{
        // 给最后一个的添加current 样式
        slide[slide.length-1].classList.add('current')
    }
    // 清除当前current 样式
    setTimeout(()=>{
        current.classList.remove('current')
    })
}
 
// 下一个
next.addEventListener('click',()=>{
    nextSlide()
})
//上一个
prev.addEventListener('click',()=>{
    prevSlide()
})


/*=============== SHOW MENU ===============*/
const navMenu = document.getElementById('nav-menu'),
      navToggle = document.getElementById('nav-toggle'),
      navClose = document.getElementById('nav-close')

/* Menu show */
navToggle.addEventListener('click', () =>{
    navMenu.classList.add('show-menu')
 })

/* Menu hidden */
 navClose.addEventListener('click', () =>{
    navMenu.classList.remove('show-menu')
 })

//  ============   登录未登录的切换 ==================
const notLogin = document.getElementById('notLogin'),
      hadLogin = document.getElementById('hadLogin')
let UserStatus = true
if(UserStatus){
    // 已登陆
    notLogin.classList.add("fade")
    hadLogin.classList.remove("fade")
}else{
    // 未登录
    hadLogin.classList.add("fade")
    notLogin.classList.remove("fade")
}


// =================右菜单 ============
let rightBarToggle = document.querySelector('.rightBar-toggler')
let rightBarMenu = document.querySelector('.rightBar')
let rightBarUl = document.querySelector('.rightBar-ul')
// .rightBar-item
rightBarToggle.addEventListener('click',function(){
    rightBarMenu.classList.toggle('active')
    rightBarToggle.classList.toggle('active')
    rightBarUl.classList.toggle('active') 
})
function removeRightBar(){
    rightBarMenu.classList.remove('active')
    rightBarToggle.classList.remove('active')
    rightBarUl.classList.remove('active') 
}
function scrollFunction() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        rightBarMenu.classList.add("show");
    } else {
        rightBarMenu.classList.remove("show");
        removeRightBar()
    }
}
// 初始化页面加载完成后调用scrollFunction函数
window.onscroll = function () {
    scrollFunction();
};
// 返回顶部
function scrollToTop() {
    window.scroll({ top: 0, behavior: 'smooth' });
}


// ================= 加载 ====================
const preloader = document.querySelector("[data-preloader]");

window.addEventListener("load", function () {
  preloader.classList.add("loaded");
  document.body.classList.add("loaded");
});

// 合作伙伴的切换
const partnerType = document.querySelectorAll('.partnerType')
const partnerList = document.querySelectorAll('.hexagon-grid-container')

partnerType.forEach(function(type,id) {
    type.addEventListener('click', function() {
        if( type.classList.contains('active')){
            return
        }
        removeTypeActive(id)
        type.classList.add('active')
    });
    type.addEventListener('animationend', function() {
        this.classList.remove('xuanback');
    });
});
function removeTypeActive(id){
    partnerType.forEach(function(type) {
            type.classList.remove('active')
    })
    partnerList.forEach(function(item,index){
            if(index == id){
                item.classList.remove('fade')
                item.classList.add('show')
            }else{
                item.classList.add('fade')
                item.classList.remove('show')
            }  

    })
}


// 精彩活动
const cards = document.querySelectorAll('.hl')
const yRange = [-10,10];
const xRange = [-10,10];
function getRoate(range,value,max){
   return value / max * (range[1]-range[0]) + range[0]
}
cards.forEach(item =>{
    item.addEventListener('mousemove',(e)=>{
        let {offsetX , offsetY} = e 
        let {offsetWidth,offsetHeight} = item
        let ry = -getRoate(yRange,offsetX,offsetWidth)
        let rx = getRoate(xRange,offsetY,offsetHeight)
        //  console.log(rx)
         item.style.setProperty('--rx',`${rx}deg`)
         item.style.setProperty('--ry',`${ry}deg`)
    })
    item.addEventListener('mouseleave',()=>{
        item.style.setProperty('--rx',`0deg`)
        item.style.setProperty('--ry',`0deg`)
   })
})
// 切换视频和图片
const hltypeItem = document.querySelectorAll('.hltype_item')
let nowHLType = 0
hltypeItem.forEach((item,index)=>{
    item.addEventListener('click',function(){
          if(index == nowHLType){
            return
          }else{
            nowHLType = index
            toggleHighLight()
          }
    })
})
const HLBox = document.querySelectorAll('.HLBox')
function toggleHighLight(){
    HLBox.forEach((item)=>{
        item.classList.toggle('fade')
    })
    hltypeItem.forEach((item)=>{
        item.classList.toggle('active')
    })
}

//精彩活动
let nowAIndex = 0
const atype_item = document.querySelectorAll('.atype_item')
const wula = document.querySelectorAll('.wula')
atype_item.forEach((item,index)=>{
    item.addEventListener('click',function(){
          if(index == nowAIndex){
            return
          }else{
            nowAIndex = index
            activityToggle(index)
          }
    })
})
function activityToggle(index){
   wula[index].checked = true
   atype_item.forEach(item =>{
     item.classList.remove('active')
   })
   atype_item[index].classList.add('active')
}

// 重磅人物
const guestItems = document.querySelectorAll('.item')
guestIndex = 0
guestItems.forEach((item)=>{
    item.addEventListener('mouseenter',function(){
        item.classList.add('active')
    })
    item.addEventListener('mouseleave',function(){
        item.classList.remove('active')
    })
})
const garrow = document.querySelector('.g_arrow')
const customCarousel =  document.querySelector('.custom-carousel')
garrow.addEventListener('click',function(){
    customCarousel.classList.toggle('trunRight')
})


// 大会议程
 // 定义变量 
 let chosenSlideNumber = 1; // 当前选择的幻灯片编号 
 let offset = 0; // 幻灯片偏移量 
 let barOffset = 0; // 导航条偏移量 
 let intervalID; // 定时器 ID 
 // 启动幻灯片轮播 
//  startSlide();
 // 获取所有抽屉按钮，并为每个按钮添加点击事件监听器 
 const drawerBtns = Array.from(document.querySelectorAll(".drawer-btn"));
 drawerBtns.forEach(btn => {
   btn.addEventListener("click", () => {
     clearInterval(intervalID); // 清除定时器 
    //  startSlide(); 
   })
 })
 // 获取幻灯片区域 
 const slideSection = document.querySelector("#slide-section");
 // 鼠标移入幻灯片区域时清除定时器 
//  slideSection.addEventListener("mouseenter", () => {
//    clearInterval(intervalID);
//  })
 // 鼠标移出幻灯片区域时重新启动幻灯片轮播 
//  slideSection.addEventListener("mouseleave", () => {
//    startSlide();
//  })
 // 切换到指定编号的幻灯片 
 function slideTo(slideNumber) {
   drawerboxToggle(slideNumber); // 切换抽屉面板状态 
   drawerbtnToggle(slideNumber); // 切换抽屉按钮状态 
   // 更新偏移量 
   let previousSlideNumber = chosenSlideNumber;
   chosenSlideNumber = slideNumber;
   offset += (chosenSlideNumber - previousSlideNumber) * (-100); // 计算幻灯片偏移量 
   barOffset += (chosenSlideNumber - previousSlideNumber) * (100); // 计算导航条偏移量 
   barSlide(barOffset); // 移动导航条 
   // 获取所有幻灯片，为每个幻灯片设置偏移量 
   const slides = document.querySelectorAll(".card");
   Array.from(slides).forEach(slide => {
     slide.style.transform = `translateY(${offset}%)`;
   })
 }
 // 切换抽屉面板状态 
 function drawerboxToggle(drawerboxNumber) {
   let prevDrawerboxNumber = chosenSlideNumber;
   const drawerboxes = document.querySelectorAll(".drawerbox");
   drawerboxes[prevDrawerboxNumber - 1].classList.toggle("active"); // 切换前一个抽屉面板的状态 
   drawerboxes[drawerboxNumber - 1].classList.toggle("active"); // 切换当前抽屉面板的状态 
 }
 // 切换抽屉按钮状态 
 function drawerbtnToggle(drawerBtnNumber) {
   let prevDrawerBtnNumber = chosenSlideNumber;
   const drawerBtns = document.querySelectorAll(".drawer-btn");
   drawerBtns[prevDrawerBtnNumber - 1].classList.toggle("active"); // 切换前一个抽屉按钮的状态 
   drawerBtns[drawerBtnNumber - 1].classList.toggle("active"); // 切换当前抽屉按钮的状态 
 }
 // 移动导航条 
 function barSlide(barOffset) {
   const bar = document.querySelector("#bar");
   bar.style.transform = `translateY(${barOffset}%)`;
 }

//  function startSlide() {
//    intervalID = setInterval(() => {
//      slideTo(chosenSlideNumber % 4 + 1); // 每次切换到下一个幻灯片 
//    }, 10000); 
//  }

//  切换日期

let ca55 = [
    {
        "name":"格致论道@西湖论剑",
        "intro":"让“圈外人”关注网络安全，让“冷”科普做到“热”传播",
        "location":"杭州市滨江区中心剧院",
        "time":"18:00 - 21:00",
        "bkImg":"https://img2023.gcsis.cn/2023/4/466ff4eaf7904e56ad9ba4c0ebeacc66.jpg"
    },
]
let ca56 = [
    {
        "name":"95后极客青年Talk",
        "intro":"西湖论剑·未来已来系列节目 新时代极客青年talk--95后“守门人”的苦辣酸甜",
        "location":"线上直播",
        "time":"10:00 - 10:30",
        "bkImg":"https://img2023.gcsis.cn/2023/5/41cb8e6a1f754988855c3f2e3b278805.png"
    },
    {
        "name":"当科幻照进现实我们会更安全吗？",
        "intro":"西湖论剑·未来已来系列节目 当科幻照进现实我们会变得更安全吗?",
        "location":"线上直播",
        "time":"13:00 - 13:30",
        "bkImg":"https://img2023.gcsis.cn/2023/5/5d7e2f0327f14c6abefe3949cf6edc38.png"
    },
    {
        "name":"人工智能会颠覆安全行业吗？",
        "intro":"ChatGPT等人工智能在狂飙，是不是给网络安全带来了新的挑战？网络安全应对挑战的思维是怎样的？且听安全官来说。",
        "location":"线上直播",
        "time":"15:00 - 15:30",
        "bkImg":"https://img2023.gcsis.cn/2023/5/5b42164afc34441ead239085ffd3c657.png"
    },
    {
        "name":"反诈直播间@西湖论剑",
        "intro":"联合网红公安民警一起，分享反诈故事，传授反诈知识，更有趣味反诈周边等你来瓜分。",
        "location":"线上直播",
        "time":"15:30 - 16:30",
        "bkImg":"https://img2023.gcsis.cn/2023/5/effacedd0d444862b56ff2cbc526e5b4.jpg"
    },
]
// 主论坛+ 订阅
// 数字安全@数字中国 新十年 新起点
let ca57 =[
    {
        "name":"主论坛",
        "intro":"数字安全@数字中国 新十年 新起点",
        "location":"杭州洲际酒店 杭州厅",
        "time":"9:00 - 12:00",
        "bkImg":"https://img2023.gcsis.cn/2023/4/fe482a3064d94335b98fa35fab1ed755.jpg"
    },
    {
        "name":"主论坛",
        "intro":"数字安全@数字中国 新十年 新起点",
        "location":"杭州洲际酒店 杭州厅",
        "time":"9:00 - 12:00",
        "bkImg":"https://img2023.gcsis.cn/2023/4/fe482a3064d94335b98fa35fab1ed755.jpg"
    },
    {
        "name":"主论坛",
        "intro":"数字安全@数字中国 新十年 新起点",
        "location":"杭州洲际酒店 杭州厅",
        "time":"9:00 - 12:00",
        "bkImg":"https://img2023.gcsis.cn/2023/4/fe482a3064d94335b98fa35fab1ed755.jpg"
    },
]
let ca58 =[
    {
        "name":"教育技术产业融合创新发展论坛",
        "intro":"多元协同，构建满足产业发展网安人才培养生态",
        "location":"线上直播",
        "time":"8:30 - 11:30",
        "bkImg":"https://img2023.gcsis.cn/2023/5/933ffa78bfad4121a1b763c6beb9f11d.jpeg"
    },
    {
        "name":"MSS安全托管运营服务论坛",
        "intro":"1.首次提出以人为中心的安全运营飞轮，筑造新一代安全运营体系，塑造安全大运营和产品即服务的理念 2.安恒信息 MSS 2.0 新安全运营体系升级发布 3.持续深入探讨MSS市场的现状和行业应用",
        "location":"线上直播",
        "time":"8:30 - 11:30",
        "bkImg":"https://img2023.gcsis.cn/2023/5/933ffa78bfad4121a1b763c6beb9f11d.jpeg"
    },
    {
        "name":"MSS安全托管运营服务论坛",
        "intro":"1.首次提出以人为中心的安全运营飞轮，筑造新一代安全运营体系，塑造安全大运营和产品即服务的理念 2.安恒信息 MSS 2.0 新安全运营体系升级发布 3.持续深入探讨MSS市场的现状和行业应用",
        "location":"线上直播",
        "time":"8:30 - 11:30",
        "bkImg":"https://img2023.gcsis.cn/2023/5/933ffa78bfad4121a1b763c6beb9f11d.jpeg"
    },
]
function changeData(array){
   let s1 =`<div id="click-section">
   <div id="drawerboxes">`
   array.forEach((item,index)=>{
    if(index + 1 ==1){
        s1 = s1+`<div class="drawerbox">
        <button class="drawer-btn active" onclick="slideTo(${index+1})">${item.name}<span
            class="drawer-head">${index+1}</span></button>
      </div>`
    }else{
        s1 = s1+`<div class="drawerbox">
        <button class="drawer-btn" onclick="slideTo(${index+1})">${item.name}<span
            class="drawer-head">${index+1}</span></button>
      </div>`
    }
   
   })
   s1 = s1 + `</div></div><div id="slide-section">
   <div id="slide-bar">
     <div id="bar"></div>
   </div>
   <div id="card-section">`

   array.forEach((item,index)=>{
    s1 = s1+` <div id="card${index+1}" class="card">
    <div class="card-small-title">${item.name}<i class="ri-map-pin-line ca_location">${item.location}</i> <i class="ri-time-line ca_time">${item.time}</i></div>
    <div class="card-content">${item.intro}<i class="ri-sparkling-fill ca_star">前往会场</i><i class="ri-sparkling-fill ca_star"></i></div>
    <div class="card-img">
      <div class="playButtonBox">
          <a class="play-button">
              <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 50 50">
                <path d="M42.7,42.7L25,50L7.3,42.7L0,25L7.3,7.3L25,0l17.7,7.3L50,25L42.7,42.7z" class="polygon"></path>
                <polygon points="32.5,25 21.5,31.4 21.5,18.6 "></polygon>
              </svg>
            </a>
      </div>
      <img src="${item.bkImg}" alt="">
    </div>
  </div>`
   })
   s1= s1+`</div></div></div></div>`
   return s1
}
let CAbox = document.getElementById('CAbox')
const caDate = document.querySelectorAll('.ctype_item')
caDate.forEach((item,index)=>{
    item.addEventListener('click',function(){
        chosenSlideNumber = 1; // 当前选择的幻灯片编号 
        offset = 0; // 幻灯片偏移量 
        barOffset = 0; // 导航条偏移量 
          if(index == 0){
            CAbox.innerHTML = changeData(ca55)
          }else if(index == 1){
            CAbox.innerHTML = changeData(ca56)
          }else if(index == 2){
            CAbox.innerHTML = changeData(ca57)
          }else{
            CAbox.innerHTML = changeData(ca58)
          }
          caDate.forEach(item=>{
            item.classList.remove('active')
          })
          item.classList.add('active')
    })
})