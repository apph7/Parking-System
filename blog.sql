-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 49.232.137.252    Database: blog
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_information`
--

DROP TABLE IF EXISTS `activity_information`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_information` (
  `activity_id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(255) NOT NULL,
  `activity_time` datetime NOT NULL,
  `activity_location` varchar(255) NOT NULL,
  `activity_content` text DEFAULT NULL,
  `has_live` tinyint(1) DEFAULT NULL,
  `video_replay_link` varchar(255) DEFAULT NULL,
  `subscription_status` tinyint(1) DEFAULT NULL,
  `activity_heat_level` int(11) DEFAULT NULL,
  PRIMARY KEY (`activity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_information`
--

LOCK TABLES `activity_information` WRITE;
/*!40000 ALTER TABLE `activity_information` DISABLE KEYS */;
INSERT INTO `activity_information` VALUES (2,'网络安全创新峰会','2023-06-10 09:00:00','杭州国际会议中心','未来网络安全趋势的主题演讲。\r\n创新技术展示，包括AI、区块链在安全领域的应用。\r\n网络安全初创企业项目路演和投资者对接。',1,'https://cas.upc.edu.cn/cas/login?service=http%3A%2F%2Fi.upc.edu.cn%2Fdcp%2Findex.jsp',0,16),(5,'数字安全与法律论坛','2024-07-05 09:00:00','浙江大学法学院报告厅','法律专家就网络安全法律问题进行深入讨论。\r\n分享网络安全相关案例分析。\r\n探讨如何在法律框架内加强数据保护。',0,NULL,NULL,NULL),(8,'网安技能大师班','2024-06-15 10:00:00','西湖论剑安全特训营基地','由行业专家领导的实战技能培训。\r\n模拟网络攻防演练。\r\n专业认证考核，为参与者提供职业发展支持。',0,'https://cas.upc.edu.cn/cas/login?service=http%3A%2F%2Fi.upc.edu.cn%2Fdcp%2Findex.jsp',NULL,NULL),(9,'网络安全公众教育日','2024-06-25 13:30:00','杭州市中心公园','面向公众的网络安全知识讲座。\r\n互动体验区，体验网络安全防御技术。\r\n家庭网络安全工作坊，教授家长如何保护家庭网络。',0,'https://cas.upc.edu.cn/cas/login?service=http%3A%2F%2Fi.upc.edu.cn%2Fdcp%2Findex.jsp',NULL,NULL),(10,'企业网络安全研讨会','2024-07-20 14:00:00','杭州经济技术开发区企业服务中心','企业网络安全管理的最佳实践分享。\r\n企业网络安全风险评估工作坊。\r\n企业网络安全政策与员工培训策略讨论。',0,NULL,NULL,NULL);
/*!40000 ALTER TABLE `activity_information` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_registration`
--

DROP TABLE IF EXISTS `activity_registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_registration` (
  `registration_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  `activity_id` int(11) NOT NULL,
  `registration_time` datetime NOT NULL,
  `registration_channel` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`registration_id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `activity_id` FOREIGN KEY (`activity_id`) REFERENCES `activity_information` (`activity_id`) ON DELETE CASCADE,
  CONSTRAINT `activity_registration_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `activity_information` (`activity_id`),
  CONSTRAINT `fk_activity_id` FOREIGN KEY (`activity_id`) REFERENCES `activity_information` (`activity_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_registration`
--

LOCK TABLES `activity_registration` WRITE;
/*!40000 ALTER TABLE `activity_registration` DISABLE KEYS */;
INSERT INTO `activity_registration` VALUES (9,'孙国铭',5,'2024-04-11 21:48:34','web');
/*!40000 ALTER TABLE `activity_registration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `activity_statistics`
--

DROP TABLE IF EXISTS `activity_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_statistics` (
  `activity_id` int(11) NOT NULL,
  `participants_count` int(11) DEFAULT NULL,
  `registration_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`activity_id`),
  CONSTRAINT `activity_statistics_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `activity_information` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_statistics`
--

LOCK TABLES `activity_statistics` WRITE;
/*!40000 ALTER TABLE `activity_statistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article`
--

DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `article_type` int(11) DEFAULT NULL,
  `issue_type` int(11) DEFAULT NULL,
  `article_pic` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `view_count` int(11) DEFAULT NULL,
  `comment_count` int(11) DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `create_time` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `markdown_content` mediumblob DEFAULT NULL,
  `html_content` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article`
--

LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
/*!40000 ALTER TABLE `article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_category`
--

DROP TABLE IF EXISTS `article_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_category` (
  `article_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL,
  PRIMARY KEY (`article_id`,`category_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_category`
--

LOCK TABLES `article_category` WRITE;
/*!40000 ALTER TABLE `article_category` DISABLE KEYS */;
INSERT INTO `article_category` VALUES (10,3),(11,2),(11,8),(13,10),(16,10),(17,13),(18,13),(21,16),(31,2);
/*!40000 ALTER TABLE `article_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_tag`
--

DROP TABLE IF EXISTS `article_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_tag` (
  `article_id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`article_id`,`tag_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_tag`
--

LOCK TABLES `article_tag` WRITE;
/*!40000 ALTER TABLE `article_tag` DISABLE KEYS */;
INSERT INTO `article_tag` VALUES (11,11),(13,8),(16,11),(17,10),(18,10),(19,9),(21,6),(21,8),(31,6);
/*!40000 ALTER TABLE `article_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_pid` int(11) DEFAULT NULL,
  `category_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_description` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (2,0,'前端','前端开发是指构建和实现网页、Web应用和移动应用的用户界面部分。前端开发涉及使用HTML、CSS和JavaScript等技术来创建和设计网页的外观和交互功能。','2023-07-30 07:04:26'),(3,2,'HTML','前端开发者使用HTML（超文本标记语言）来创建网页的结构。他们将不同的HTML标签和元素组合起来，形成标题、段落、图像和链接等页面元素。HTML为内容提供了语义化的结构，使用户可以通过浏览器查看和理解网页的信息。','2023-07-30 07:04:53'),(8,2,'CSS','CSS（层叠样式表）是前端开发中用来控制网页样式和布局的技术。通过CSS，开发者可以设置网页的字体、颜色、边距、背景以及其他外观属性。CSS使得开发者可以根据设计需求来精确控制网页的视觉效果，并使其具有吸引力和一致性。','2023-07-30 12:38:14'),(10,0,'后端','后端通常指的是在应用程序中负责处理后台逻辑和数据处理的部分。在 Web 开发中，后端主要涉及服务器端的编程和数据处理。','2023-07-30 12:44:55'),(13,0,'人工智能','人工智能（Artificial Intelligence，AI）是一门研究和开发计算机系统，使其能够执行需要人类智能的任务。它涉及构建智能代理，使其能够感知环境、理解语言、学习知识、推理推断、做出决策和解决问题等。','2023-07-30 12:49:43'),(16,0,'计算机网络','计算机网络指的是将多台计算机连接在一起，通过通信设备和协议实现数据交换和资源共享的系统。计算机网络常用于实现广域网 (WAN)、局域网 (LAN)、城域网 (MAN) 等不同规模和范围的网络。','2023-07-30 12:51:35'),(21,13,'神经网络','神经网络（Neural Network）是一种受到生物神经系统启发的机器学习模型。它由多个人工神经元组成并通过连接强化彼此之间的信息传递。神经网络通常用于解决各种任务，包括模式识别、分类、回归、聚类等。','2023-08-01 07:01:04');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) DEFAULT NULL,
  `head_pic` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment_pid` int(11) DEFAULT NULL,
  `comment_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment_email` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment_content` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (8,13,NULL,0,'Wanhong Li','124235735@qq.com','写的太棒了！对我太有用了！','2023-07-30 15:05:36'),(9,21,NULL,0,'FancyYeach','2134765791@qq.com','博主好厉害！跟着博主学到了好多！','2023-07-30 15:15:21'),(10,21,NULL,0,'Xintong Lv','3456336852@qq.com','这也写得太棒了吧！太有用了！！！','2023-07-30 15:16:49'),(11,21,NULL,10,'Ahan','3456336852@qq.com','woshi','2024-04-12 12:34:17'),(12,21,NULL,9,'Ahan','2134765791@qq.com','谢谢！','2023-07-30 15:18:04'),(13,13,NULL,8,'Ahan','124235735@qq.com','有用就好哈哈哈哈','2023-07-30 15:18:22'),(14,13,NULL,8,'Ahan','124235735@qq.com','很开心对您有用呢','2023-07-31 13:06:10'),(15,19,NULL,0,'f','3470408932@qq.com','太有用了!','2023-08-01 01:05:23'),(16,19,NULL,0,'FancyYeach','3470408932@qq.com','太棒了！','2023-08-01 06:25:55'),(17,19,NULL,16,'Ahan','3470408932@qq.com','哈哈哈哈','2023-08-01 07:17:32'),(18,19,NULL,0,'e','3470408932@qq.com','太好了','2023-08-01 07:55:03');
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments_interactions`
--

DROP TABLE IF EXISTS `comments_interactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments_interactions` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) DEFAULT NULL,
  `activity_id` int(11) NOT NULL,
  `comment_content` text DEFAULT NULL,
  `comment_time` datetime DEFAULT NULL,
  `likes_count` int(11) DEFAULT 0,
  `shares_count` int(11) DEFAULT 0,
  `replies_count` int(11) DEFAULT 0,
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments_interactions`
--

LOCK TABLES `comments_interactions` WRITE;
/*!40000 ALTER TABLE `comments_interactions` DISABLE KEYS */;
INSERT INTO `comments_interactions` VALUES (1,'安全先锋',1,'\"西湖论剑·数字安全大会是一年一度的行业盛事，每次都能收获满满的知识和启发。今年的议程非常丰富，特别是关于新兴技术的安全挑战的讨论，让我受益匪浅。期待明年的大会！\"','2024-03-21 16:36:15',2,1,3),(2,'技术探索者',1,'\"作为一个IT从业者，我觉得西湖论剑安全特训营是一个非常有价值的平台。它不仅提供了实战化的学习机会，还能让我们这些从业者与顶尖专家直接交流。强烈推荐给同行们！\"','2024-03-26 16:39:03',0,0,0),(4,' 网安新兵',1,'\"我是第一次参加西湖论剑的活动，感觉非常震撼。通过‘掌上论剑’系列活动，我能够随时随地了解最新的网络安全动态。希望未来能有更多这样的活动，让网络安全知识更加普及。\"','2024-03-26 16:49:47',0,0,0),(5,'未来守护者',8,'\"西湖论剑·网络安全大会不仅为我们提供了学习的平台，更是一个思想碰撞和创新交流的场所。感谢组织者精心策划的每一场活动，让我们能够共同为构建更安全的数字世界而努力。\"','2024-04-01 12:46:18',0,0,0),(6,'科普传播者',0,'\"‘让‘圈外人’关注网络安全’，西湖论剑做到了！通过生动有趣的科普内容，让我们这些非专业人士也能轻松理解网络安全的重要性。希望未来能有更多类似的科普活动，让网络安全意识','2024-04-02 14:55:22',0,0,0);
/*!40000 ALTER TABLE `comments_interactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expand`
--

DROP TABLE IF EXISTS `expand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time` timestamp NULL DEFAULT current_timestamp(),
  `user_id` varchar(255) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `likes` int(11) DEFAULT 0,
  `shares` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expand`
--

LOCK TABLES `expand` WRITE;
/*!40000 ALTER TABLE `expand` DISABLE KEYS */;
INSERT INTO `expand` VALUES (1,'2024-04-01 06:22:52','安全先锋','\"西湖论剑·数字安全大会是一年一度的行业盛事，每次都能收获满满的知识和启发。今年的议程非常丰富，特别是关于新兴技术的安全挑战的讨论，让我受益匪浅。期待明年的大会！\"',0,0),(2,'2024-04-01 06:27:28','技术探索者','\"作为一个IT从业者，我觉得西湖论剑安全特训营是一个非常有价值的平台。它不仅提供了实战化的学习机会，还能让我们这些从业者与顶尖专家直接交流。强烈推荐给同行们！\"',0,0),(3,'2024-04-01 06:33:33','网安新兵','\"我是第一次参加西湖论剑的活动，感觉非常震撼。通过‘掌上论剑’系列活动，我能够随时随地了解最新的网络安全动态。希望未来能有更多这样的活动，让网络安全知识更加普及。\"',0,0),(4,'2024-04-02 06:30:24','未来守护者','\"西湖论剑·网络安全大会不仅为我们提供了学习的平台，更是一个思想碰撞和创新交流的场所。感谢组织者精心策划的每一场活动，让我们能够共同为构建更安全的数字世界而努力。\"',0,0),(5,'2024-04-02 06:41:26','科普传播者','\"‘让‘圈外人’关注网络安全’，西湖论剑做到了！通过生动有趣的科普内容，让我们这些非专业人士也能轻松理解网络安全的重要性。希望未来能有更多类似的科普活动，让网络安全意识深入人心。\"\r\n\r\n',0,0);
/*!40000 ALTER TABLE `expand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `firm` varchar(255) DEFAULT NULL,
  `sex` varchar(255) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guest`
--

LOCK TABLES `guest` WRITE;
/*!40000 ALTER TABLE `guest` DISABLE KEYS */;
INSERT INTO `guest` VALUES (1,'18263632395','a','a@','a',NULL,NULL,NULL),(2,'18954831336','123456','2841578001@qq.com','222',NULL,NULL,NULL),(3,'技术探索者','666888aa','2398625952@qq.com','18263632395',NULL,NULL,0),(4,'安全先锋','password123','example@example.com','1234567890',NULL,NULL,0),(5,'未来守护者','secret456','user@example.com','9876543210',NULL,NULL,0),(6,'科普传播者','letmein','info@example.com','1357924680',NULL,NULL,0);
/*!40000 ALTER TABLE `guest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `log_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `log_detail` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=275 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
INSERT INTO `log` VALUES (119,'登录','登录成功','0:0:0:0:0:0:0:1','2023-08-01 07:39:55'),(120,'登录','登录成功','0:0:0:0:0:0:0:1','2023-08-01 07:41:10'),(121,'登录','登录成功','0:0:0:0:0:0:0:1','2023-08-01 07:48:07'),(122,'登录','登录成功','0:0:0:0:0:0:0:1','2023-08-01 07:56:32'),(123,'登录','登录成功','0:0:0:0:0:0:0:1','2023-08-01 07:59:15'),(125,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-12 13:09:34'),(126,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-12 13:09:36'),(127,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-12 13:09:47'),(128,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-12 13:13:21'),(129,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-12 13:15:42'),(130,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-13 12:39:49'),(131,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-14 06:01:25'),(132,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-14 06:02:48'),(133,NULL,NULL,'0:0:0:0:0:0:0:1','2024-03-14 07:20:33'),(134,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-14 09:28:07'),(135,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-14 11:35:22'),(136,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-14 11:38:59'),(137,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-14 11:39:00'),(138,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-14 11:39:23'),(139,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-14 11:59:45'),(140,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-14 12:00:11'),(141,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-14 12:00:21'),(142,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-26 14:43:12'),(143,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 06:08:08'),(144,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 06:12:19'),(145,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 06:19:41'),(146,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 06:42:38'),(147,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 06:45:56'),(148,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 06:54:06'),(149,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 06:58:14'),(150,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:00:21'),(151,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:01:32'),(152,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:02:14'),(153,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:03:38'),(154,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:05:21'),(155,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:07:44'),(156,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:10:05'),(157,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:20:34'),(158,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:34:03'),(159,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:35:19'),(160,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:38:06'),(161,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:40:27'),(162,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:51:25'),(163,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:54:46'),(164,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 07:57:25'),(165,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:01:54'),(166,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:03:13'),(167,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:09:24'),(168,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:13:01'),(169,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:15:39'),(170,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:18:19'),(171,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:19:29'),(172,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:20:33'),(173,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:24:27'),(174,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:28:08'),(175,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:30:01'),(176,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:35:59'),(177,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:37:41'),(178,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:39:19'),(179,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:42:30'),(180,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:44:02'),(181,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:46:56'),(182,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:48:01'),(183,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:51:37'),(184,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 08:54:42'),(185,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 09:00:24'),(186,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 09:17:55'),(187,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 09:20:50'),(188,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 09:22:41'),(189,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 09:24:37'),(190,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 09:27:09'),(191,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 09:28:30'),(192,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 10:25:57'),(193,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 10:35:27'),(194,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 10:36:52'),(195,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 10:38:15'),(196,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 10:38:19'),(197,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 10:39:57'),(198,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 10:43:21'),(199,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 10:45:27'),(200,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 10:55:43'),(201,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:07:45'),(202,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:09:36'),(203,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:12:23'),(204,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:15:00'),(205,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:17:15'),(206,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:20:17'),(207,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:22:04'),(208,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:23:39'),(209,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:27:05'),(210,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:33:48'),(211,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:36:02'),(212,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:39:25'),(213,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:43:33'),(214,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 11:44:34'),(215,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 14:34:35'),(216,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 14:38:02'),(217,'登录','登录失败','0:0:0:0:0:0:0:1','2024-03-28 14:42:05'),(218,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-28 14:42:08'),(219,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 01:29:51'),(220,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 11:52:45'),(221,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 11:59:27'),(222,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 12:02:22'),(223,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 12:03:06'),(224,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 12:04:34'),(225,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 12:08:57'),(226,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 12:09:48'),(227,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 12:11:13'),(228,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 12:15:00'),(229,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 12:21:52'),(230,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-29 12:24:29'),(231,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-31 13:14:36'),(232,'登录','登录成功','0:0:0:0:0:0:0:1','2024-03-31 14:06:32'),(233,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-02 06:33:35'),(234,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-02 07:25:23'),(235,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-02 07:48:44'),(236,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-02 07:49:08'),(237,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-02 08:09:34'),(238,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-09 07:10:28'),(239,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-09 07:37:47'),(240,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-09 07:40:04'),(241,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-09 07:41:12'),(242,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-09 07:42:51'),(243,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-11 06:17:07'),(244,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-11 07:38:00'),(245,'登录','登录失败','0:0:0:0:0:0:0:1','2024-04-11 07:41:23'),(246,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-11 07:41:25'),(247,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-11 07:49:35'),(248,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-11 08:00:05'),(249,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-11 08:02:24'),(250,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-11 08:04:17'),(251,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-11 08:05:38'),(252,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-11 08:06:54'),(253,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-11 08:59:14'),(254,'登录','登录成功','123.168.74.245','2024-04-11 15:39:28'),(255,'登录','登录成功','123.168.74.245','2024-04-11 16:05:19'),(256,'登录','登录成功','123.168.74.216','2024-04-11 16:23:08'),(257,'登录','登录成功','223.81.192.220','2024-04-12 01:11:58'),(258,'登录','登录成功','123.168.74.59','2024-04-12 09:12:10'),(259,'登录','登录成功','123.168.74.59','2024-04-12 09:12:36'),(260,'登录','登录成功','123.168.74.59','2024-04-12 09:12:50'),(261,'登录','登录成功','123.168.74.14','2024-04-12 11:40:36'),(262,'登录','登录成功','60.209.187.52','2024-04-12 12:33:34'),(263,'登录','登录成功','123.168.74.14','2024-04-12 13:16:40'),(264,'登录','登录成功','123.168.74.59','2024-04-12 13:29:07'),(265,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-12 14:09:23'),(266,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-12 14:17:50'),(267,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-12 14:19:23'),(268,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-12 14:21:38'),(269,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-12 14:23:12'),(270,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-12 14:24:43'),(271,'登录','登录成功','0:0:0:0:0:0:0:1','2024-04-12 14:26:04'),(272,'登录','登录成功','123.168.74.14','2024-04-13 11:27:48'),(273,'登录','登录成功','123.168.74.14','2024-04-14 08:00:48'),(274,'登录','登录成功','223.81.193.171','2024-04-14 08:00:50');
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `start_date` varchar(255) DEFAULT NULL,
  `end_date` varchar(255) DEFAULT NULL,
  `location` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (1,'“我在西湖论剑等你”——积分打卡抽奖活动','【活动公告】“我在西湖论剑等你”——积分打卡抽奖活动。<br>亲爱的朋友们：为了增进大家对西湖论剑的了解，感受数字安全的重要性，我们特别策划了此次“我在西湖论剑等你”活动。只需参与活动并完成签到打卡，就有机会获得丰富奖品哦！以下是活动详情：<br><br>参与方式： 在活动期间,可以参加签到、打卡、话题讨论和活动分享等等活动<br>四、积分获取： 参与活动完成任务,即可获得积分。 积分可累积,具体详情见抽奖页<br>五、抽奖方式： 活动结束前,参与者可随意进行抽奖。奖品数量不设限，中奖概率越大！，奖品丰富，等你来拿！<br><br>六、注意事项：<br>1.参与者需保证照片和文字内容真实有效，一经发现作弊行为，将取消参与资格。<br>2.照片和文字内容需符合社会主义核心价值观，传播正能量。<br>3.本活动最终解释权归主办方所有。<br>快来参与本次活动吧，用镜头记录美好时光，用文字分享感动瞬间！让我们一起探索西湖论剑的独特魅力，期待与你相遇！','2024-03-23','2024-05-10','中国杭州');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `photo_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `photo_pic` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photos`
--

LOCK TABLES `photos` WRITE;
/*!40000 ALTER TABLE `photos` DISABLE KEYS */;
INSERT INTO `photos` VALUES (37,'薇尔莉特','/static/upload/2024/03/28/cb304624-5ea3-4cbd-8812-ab3b17c88b53_4e48bf2d53wXxZw.jpg'),(38,'','/static/upload/2024/04/14/b052ed6f-0bf3-48df-95af-3b25ea01b397_1.png');
/*!40000 ALTER TABLE `photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(255) NOT NULL,
  `font_size` varchar(255) NOT NULL,
  `font_color` varchar(255) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES (6,'Java','30px','#91305a','2023-07-30 12:53:34'),(7,'算法','40px','#6a432a','2023-07-30 12:53:48'),(8,'数据结构','20px','#6029b3','2023-07-30 12:54:06'),(9,'操作系统','35px','#3340a3','2023-07-30 12:54:28'),(10,'机器学习','20px','#3caa94','2023-07-30 12:54:53'),(11,'Spring','15px','#f5f17a','2023-07-30 12:55:32');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `head_pic` varchar(255) NOT NULL,
  `user_nickname` varchar(255) NOT NULL,
  `user_signature` varchar(255) NOT NULL,
  `user_email` varchar(255) NOT NULL,
  `user_tag` varchar(255) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `markdown_content` varchar(255) DEFAULT NULL,
  `html_content` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','c4ca4238a0b923820dcc509a6f75849b','/static/images/headPic/2023/08/01/6f52b1b4-6aa9-40a8-bcb1-f1464d0f89a2_IMG_20220224_101500.jpg','Ahan','vx:1111111','2841578001','快乐','2023-08-01 07:59:40','',''),(2,'user1','password1','','','','','','2024-03-14 08:17:54',NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitor`
--

DROP TABLE IF EXISTS `visitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(255) NOT NULL,
  `brower` varchar(255) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=275 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitor`
--

LOCK TABLES `visitor` WRITE;
/*!40000 ALTER TABLE `visitor` DISABLE KEYS */;
INSERT INTO `visitor` VALUES (236,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36','2023-08-01 07:55:04'),(237,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36','2023-08-01 07:55:32'),(238,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36','2023-08-01 07:55:43'),(239,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36','2023-08-01 07:56:09'),(240,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36','2023-08-01 07:59:07'),(241,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36','2023-08-01 08:59:22'),(242,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36','2023-08-01 08:59:45'),(243,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36','2023-08-01 09:00:15'),(244,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36','2023-08-01 09:02:53'),(246,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36','2023-08-21 05:23:16'),(247,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36','2023-08-21 05:23:53'),(248,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36','2023-08-21 05:24:32'),(249,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36','2023-08-21 05:24:42'),(251,'127.0.0.1','IntelliJ IDEA/191.7479.19','2024-02-29 06:43:52'),(252,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36','2024-02-29 06:43:53'),(253,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36','2024-02-29 06:44:04'),(254,'127.0.0.1','IntelliJ IDEA/191.7479.19','2024-03-05 06:13:55'),(255,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36','2024-03-05 06:13:58'),(256,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36','2024-03-05 06:14:24'),(257,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36','2024-03-05 06:16:13'),(258,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-12 13:31:51'),(259,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-13 12:40:24'),(260,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-14 12:07:07'),(261,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-16 12:47:25'),(262,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-16 12:55:30'),(263,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-16 12:55:34'),(264,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-28 06:08:50'),(265,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-28 06:11:40'),(266,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-28 06:14:33'),(267,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-28 06:21:50'),(268,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-28 07:10:09'),(269,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-28 07:10:15'),(270,'0:0:0:0:0:0:0:1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 Edg/122.0.0.0','2024-03-28 07:11:33'),(272,'223.81.192.220','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36 Edg/118.0.2088.57','2024-04-12 01:12:50'),(273,'129.211.162.23','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36 Edg/118.0.2088.57','2024-04-12 02:32:55');
/*!40000 ALTER TABLE `visitor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'blog'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-15 21:21:36
