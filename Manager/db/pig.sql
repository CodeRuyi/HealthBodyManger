-- MySQL dump 10.13  Distrib 8.0.27, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: pig
-- ------------------------------------------------------
-- Server version	8.0.27

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
-- Table structure for table `article`
--

DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cate_id` int DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `views` int DEFAULT '0',
  `shares` int DEFAULT '0',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '已发布',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article`
--

LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` VALUES (1,'当你想要暴食时，这5页纸能救命',1,'暴食自救方法...',1200,350,'已发布','2026-03-05 19:01:04'),(2,'如何通过情绪管理告别暴食',2,'情绪控制技巧...',850,210,'已发布','2026-03-05 19:01:04'),(3,'健康饮食结构指南',3,'科学饮食方法...',620,150,'已发布','2026-03-05 19:01:04'),(4,'三个月康复者真实经历',4,'康复故事分享...',940,280,'已发布','2026-03-05 19:01:04');
/*!40000 ALTER TABLE `article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_category`
--

DROP TABLE IF EXISTS `article_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_category`
--

LOCK TABLES `article_category` WRITE;
/*!40000 ALTER TABLE `article_category` DISABLE KEYS */;
INSERT INTO `article_category` VALUES (1,'自救指南',1),(2,'情绪调节',2),(3,'饮食知识',3),(4,'康复案例',4);
/*!40000 ALTER TABLE `article_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_tags`
--

DROP TABLE IF EXISTS `article_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_tags` (
  `article_id` int NOT NULL,
  `tag_id` int NOT NULL,
  PRIMARY KEY (`article_id`,`tag_id`) USING BTREE,
  UNIQUE KEY `article_tags_tag_id_article_id_unique` (`article_id`,`tag_id`) USING BTREE,
  KEY `tag_id` (`tag_id`) USING BTREE,
  CONSTRAINT `article_tags_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `article_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_tags`
--

LOCK TABLES `article_tags` WRITE;
/*!40000 ALTER TABLE `article_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_versions`
--

DROP TABLE IF EXISTS `article_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_versions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `article_id` int NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `editor_id` int NOT NULL COMMENT '执行编辑操作的用户',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `article_id` (`article_id`) USING BTREE,
  KEY `editor_id` (`editor_id`) USING BTREE,
  CONSTRAINT `article_versions_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `article_versions_ibfk_2` FOREIGN KEY (`editor_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_versions`
--

LOCK TABLES `article_versions` WRITE;
/*!40000 ALTER TABLE `article_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `article_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Markdown 格式正文',
  `summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '文章摘要，用于列表预览',
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '封面图 URL（本地路径或 OSS 链接）',
  `author_id` int NOT NULL,
  `category_id` int NOT NULL,
  `status` enum('draft','published','offline') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'draft' COMMENT 'draft=草稿, published=已发布, offline=已下架',
  `view_count` int DEFAULT '0',
  `share_count` int DEFAULT '0',
  `heat_score` float DEFAULT '0' COMMENT '热度值 = view_count * 0.4 + share_count * 0.6',
  `featured` tinyint(1) DEFAULT '0' COMMENT '是否精选',
  `published_at` datetime DEFAULT NULL COMMENT '实际发布时间',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `articles_status` (`status`) USING BTREE,
  KEY `articles_category_id` (`category_id`) USING BTREE,
  KEY `articles_author_id` (`author_id`) USING BTREE,
  KEY `articles_heat_score` (`heat_score`) USING BTREE,
  CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `articles_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
INSERT INTO `articles` VALUES (1,'当你想要暴食时，这5页纸能救命','# 当你想要暴食时，这5页纸能救命\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','当你想要暴食时，这5页纸能救命 — 这是文章摘要，简要描述文章的主要内容。',NULL,2,1,'published',12482,836,5494.4,1,'2026-02-25 09:19:28','2026-03-06 00:04:24','2026-03-11 18:38:55'),(2,'暴食后的24小时修复计划','# 暴食后的24小时修复计划\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','暴食后的24小时修复计划 — 这是文章摘要，简要描述文章的主要内容。',NULL,4,1,'published',9320,612,4095.2,1,'2026-03-02 03:52:02','2026-03-06 00:04:24','2026-03-06 00:04:24'),(3,'为什么心情沮丧就想吃炸鸡？','# 为什么心情沮丧就想吃炸鸡？\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','为什么心情沮丧就想吃炸鸡？ — 这是文章摘要，简要描述文章的主要内容。',NULL,1,2,'published',8105,504,3544.4,0,'2026-01-06 11:16:59','2026-03-06 00:04:24','2026-03-06 00:04:24'),(4,'情绪性进食的7个预警信号','# 情绪性进食的7个预警信号\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','情绪性进食的7个预警信号 — 这是文章摘要，简要描述文章的主要内容。',NULL,2,2,'published',6788,389,2948.6,1,'2026-02-12 13:55:57','2026-03-06 00:04:24','2026-03-06 00:04:24'),(5,'低卡高蛋白饱腹沙拉合集','# 低卡高蛋白饱腹沙拉合集\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','低卡高蛋白饱腹沙拉合集 — 这是文章摘要，简要描述文章的主要内容。',NULL,3,3,'published',5440,718,2606.8,0,'2026-01-29 06:16:33','2026-03-06 00:04:24','2026-03-06 00:04:24'),(6,'科学进食时间表：如何安排三餐','# 科学进食时间表：如何安排三餐\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','科学进食时间表：如何安排三餐 — 这是文章摘要，简要描述文章的主要内容。',NULL,1,4,'published',4912,291,2139.4,1,'2026-01-20 17:40:27','2026-03-06 00:04:24','2026-03-06 00:04:24'),(7,'正念饮食练习：每一口都值得感受','# 正念饮食练习：每一口都值得感受\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','正念饮食练习：每一口都值得感受 — 这是文章摘要，简要描述文章的主要内容。',NULL,2,4,'published',3867,220,1678.8,0,'2026-01-24 03:12:02','2026-03-06 00:04:24','2026-03-06 00:04:24'),(8,'15分钟低卡晚餐：番茄豆腐汤','# 15分钟低卡晚餐：番茄豆腐汤\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','15分钟低卡晚餐：番茄豆腐汤 — 这是文章摘要，简要描述文章的主要内容。',NULL,3,3,'published',3210,405,1527,0,'2026-02-01 15:37:00','2026-03-06 00:04:24','2026-03-06 00:04:24'),(9,'如何建立稳定的饥饿感信号？','# 如何建立稳定的饥饿感信号？\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','如何建立稳定的饥饿感信号？ — 这是文章摘要，简要描述文章的主要内容。',NULL,4,4,'published',2980,178,1298.8,0,'2026-01-13 21:05:02','2026-03-06 00:04:24','2026-03-06 00:04:24'),(10,'写给自己的暴食后原谅信','# 写给自己的暴食后原谅信\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','写给自己的暴食后原谅信 — 这是文章摘要，简要描述文章的主要内容。',NULL,1,2,'published',2540,490,1310,1,'2026-02-02 01:59:54','2026-03-06 00:04:24','2026-03-06 00:04:24'),(11,'睡前暴食冲动应对手册','# 睡前暴食冲动应对手册\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','睡前暴食冲动应对手册 — 这是文章摘要，简要描述文章的主要内容。',NULL,1,1,'draft',0,0,0,0,NULL,'2026-03-06 00:04:24','2026-03-06 00:04:24'),(12,'低卡甜品：椰子冻','# 低卡甜品：椰子冻\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','低卡甜品：椰子冻 — 这是文章摘要，简要描述文章的主要内容。',NULL,3,3,'draft',0,0,0,0,NULL,'2026-03-06 00:04:24','2026-03-06 00:04:24'),(13,'暴食与童年经历有关吗？','# 暴食与童年经历有关吗？\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','暴食与童年经历有关吗？ — 这是文章摘要，简要描述文章的主要内容。',NULL,2,2,'draft',0,0,0,0,NULL,'2026-03-06 00:04:24','2026-03-06 00:04:24'),(14,'不节食也能瘦：科学解读','# 不节食也能瘦：科学解读\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','不节食也能瘦：科学解读 — 这是文章摘要，简要描述文章的主要内容。',NULL,1,4,'draft',0,0,0,0,NULL,'2026-03-06 00:04:24','2026-03-06 00:04:24'),(15,'夜间进食障碍全指南','# 夜间进食障碍全指南\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','夜间进食障碍全指南 — 这是文章摘要，简要描述文章的主要内容。',NULL,4,1,'draft',0,0,0,0,NULL,'2026-03-06 00:04:24','2026-03-06 00:04:24'),(16,'极端节食的危害','# 极端节食的危害\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','极端节食的危害 — 这是文章摘要，简要描述文章的主要内容。',NULL,1,4,'offline',1022,88,461.6,0,NULL,'2026-03-06 00:04:24','2026-03-06 00:04:24'),(17,'暴食者的饮食日记模板','# 暴食者的饮食日记模板\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','暴食者的饮食日记模板 — 这是文章摘要，简要描述文章的主要内容。',NULL,3,1,'offline',876,56,384,0,NULL,'2026-03-06 00:04:24','2026-03-06 00:04:24'),(18,'旧版低卡食谱合集2024','# 旧版低卡食谱合集2024\n\n> 这是一篇关于**防暴食**与饮食健康的科普文章。\n\n## 前言\n\n正文内容支持 Markdown 格式，可以使用标题、列表、代码块、加粗等格式。\n\n## 主要内容\n\n1. 第一点内容\n2. 第二点内容\n3. 第三点内容\n\n## 小结\n\n本文总结...','旧版低卡食谱合集2024 — 这是文章摘要，简要描述文章的主要内容。',NULL,3,3,'offline',2130,112,919.2,0,NULL,'2026-03-06 00:04:24','2026-03-06 00:04:24');
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cal`
--

DROP TABLE IF EXISTS `cal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cal` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `food` varchar(50) NOT NULL COMMENT '食物名称',
  `calorie` int NOT NULL COMMENT '卡路里（千卡/100克/份）',
  `exer` varchar(100) NOT NULL COMMENT '对应运动消耗',
  `imgSrc` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='食物卡路里与运动消耗对照表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cal`
--

LOCK TABLES `cal` WRITE;
/*!40000 ALTER TABLE `cal` DISABLE KEYS */;
INSERT INTO `cal` VALUES (1,'汉堡',250,'慢跑30分钟','./img/汉堡.png'),(2,'薯条',312,'快走40分钟','./img/薯条.png'),(3,'炸鸡',270,'跳绳25分钟','./img/炸鸡.png'),(4,'可乐',42,'散步15分钟','./img/可乐.png'),(5,'麻辣烫',150,'瑜伽20分钟','./img/麻辣烫.png'),(6,'螺蛳粉',180,'开合跳25分钟','./img/螺蛳粉.png'),(7,'炸串',220,'平板支撑3组（每组1分钟）','./img/炸串.png'),(8,'烤肠',190,'深蹲30个','./img/烤肠.png'),(9,'奶茶（全糖）',150,'爬楼梯10层','./img/奶茶.png'),(10,'油条',380,'游泳15分钟','./img/油条.png');
/*!40000 ALTER TABLE `cal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类显示名称，如"自救指南"',
  `slug` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类标识符，如"self-help"，用于前端筛选',
  `sort_order` int DEFAULT '0' COMMENT '排序权重，数字越小越靠前',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `slug` (`slug`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'自救指南','self-help',1,'2026-03-06 00:04:24','2026-03-06 00:04:24'),(2,'情绪调节','emotion',2,'2026-03-06 00:04:24','2026-03-06 00:04:24'),(3,'低卡食谱','recipe',3,'2026-03-06 00:04:24','2026-03-06 00:04:24'),(4,'科学进食','science',4,'2026-03-06 00:04:24','2026-03-06 00:04:24');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dietitian`
--

DROP TABLE IF EXISTS `dietitian`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dietitian` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `qualify_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '待审核',
  `online_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '离线',
  `score` decimal(5,1) DEFAULT '0.0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dietitian`
--

LOCK TABLES `dietitian` WRITE;
/*!40000 ALTER TABLE `dietitian` DISABLE KEYS */;
INSERT INTO `dietitian` VALUES (1,'张医生',NULL,'已认证','在线',99.4,'2026-03-05 18:59:10'),(2,'李医师',NULL,'已认证','离线',97.8,'2026-03-05 18:59:10'),(3,'王营养师',NULL,'审核中','离线',95.2,'2026-03-05 18:59:10'),(4,'赵顾问',NULL,'已认证','在线',98.1,'2026-03-05 18:59:10');
/*!40000 ALTER TABLE `dietitian` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `pay_amount` decimal(10,2) DEFAULT '0.00',
  `expire_time` datetime DEFAULT NULL,
  `risk_value` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_set`
--

DROP TABLE IF EXISTS `member_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_set` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '性别',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号',
  `level` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '等级身份',
  `total_fee` decimal(10,2) DEFAULT '0.00' COMMENT '累计付费',
  `expire_time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '到期时间',
  `status` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='会员信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_set`
--

LOCK TABLES `member_set` WRITE;
/*!40000 ALTER TABLE `member_set` DISABLE KEYS */;
INSERT INTO `member_set` VALUES (1,'陈老师','男','13800138001',NULL,NULL,NULL,NULL),(2,'李四','女','13800138002','高级会员',599.00,'2026-08-15','正常'),(3,'王五','男','13800138003','普通会员',199.00,'2025-12-30','过期'),(4,'赵六','女','13800138004','VIP会员',999.00,'2027-01-20','正常'),(5,'钱七','男','13800138005','高级会员',599.00,'2026-04-10','正常'),(6,'孙八','女','13800138006','普通会员',199.00,'2026-03-15','正常'),(7,'周九','男','13800138007','VIP会员',999.00,'2026-12-12','正常'),(8,'吴十','女','13800138008','高级会员',599.00,'2025-11-05','过期'),(9,'郑十一','男','13800138009','普通会员',199.00,'2026-06-01','正常'),(10,'王十二','女','13800138010','VIP会员',999.00,'2027-02-28','正常'),(11,'刘十三','男','13800138011','高级会员',599.00,'2026-07-07','正常'),(12,'陈十四','女','13800138012','普通会员',199.00,'2025-10-01','过期'),(13,'杨十五','男','13800138013','VIP会员',999.00,'2026-09-30','正常'),(14,'黄十六','女','13800138014','高级会员',599.00,'2026-05-20','正常'),(15,'吴十七','男','13800138015','普通会员',199.00,'2026-04-01','正常'),(16,'赵十八','女','13800138016','VIP会员',999.00,'2027-03-10','正常'),(17,'钱十九','男','13800138017','高级会员',599.00,'2026-08-08','正常'),(18,'孙二十','女','13800138018','普通会员',199.00,'2025-09-15','过期'),(19,'周二十一','男','13800138019','VIP会员',999.00,'2026-10-05','正常'),(20,'郑二十二','女','13800138020','高级会员',599.00,'2026-06-25','正常'),(21,'王二十三','男','13800138021','普通会员',199.00,'2026-07-19','正常'),(22,'李二十四','女','13800138022','VIP会员',999.00,'2027-01-01','正常'),(23,'张二十五','男','13800138023','高级会员',599.00,'2026-09-09','正常'),(24,'刘二十六','女','13800138024','普通会员',199.00,'2025-08-08','过期'),(25,'陈二十七','男','13800138025','VIP会员',999.00,'2026-11-11','正常'),(26,'杨二十八','女','13800138026','高级会员',599.00,'2026-04-29','正常'),(27,'黄二十九','男','13800138027','普通会员',199.00,'2026-05-30','正常'),(28,'吴三十','女','13800138028','VIP会员',999.00,'2027-04-04','正常'),(29,'赵三十一','男','13800138029','高级会员',599.00,'2026-10-10','正常'),(30,'钱三十二','女','13800138030','普通会员',199.00,'2025-07-07','过期');
/*!40000 ALTER TABLE `member_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nutritionists`
--

DROP TABLE IF EXISTS `nutritionists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nutritionists` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) NOT NULL COMMENT '营养师姓名',
  `title` varchar(50) NOT NULL COMMENT '职称（高级营养师、核心专家等）',
  `status` varchar(50) NOT NULL DEFAULT '已认证' COMMENT '认证状态（已认证、待复审）',
  `uid` varchar(32) DEFAULT NULL COMMENT '工号/UID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='营养师认证表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nutritionists`
--

LOCK TABLES `nutritionists` WRITE;
/*!40000 ALTER TABLE `nutritionists` DISABLE KEYS */;
INSERT INTO `nutritionists` VALUES (1,'张老师','高级营养师','已认证',NULL,'2026-03-22 16:23:56'),(2,'李老师','核心专家','已认证',NULL,'2026-03-22 16:23:56'),(3,'王老师','营养师','待复审',NULL,'2026-03-22 16:23:56'),(4,'赵老师','营养师','已认证',NULL,'2026-03-22 16:23:56'),(5,'陈老师','新锐营养师','已认证',NULL,'2026-03-22 16:23:56');
/*!40000 ALTER TABLE `nutritionists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation_logs`
--

DROP TABLE IF EXISTS `operation_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operation_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action` enum('create','update','delete','publish','offline','restore') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作对象类型，如 article、category、user',
  `target_id` int DEFAULT NULL,
  `detail` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '操作详情描述',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  CONSTRAINT `operation_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation_logs`
--

LOCK TABLES `operation_logs` WRITE;
/*!40000 ALTER TABLE `operation_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `operation_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pigappusers`
--

DROP TABLE IF EXISTS `pigappusers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pigappusers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `phone` (`phone`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pigappusers`
--

LOCK TABLES `pigappusers` WRITE;
/*!40000 ALTER TABLE `pigappusers` DISABLE KEYS */;
INSERT INTO `pigappusers` VALUES (1,'13800138001','123456','user1@qq.com','2026-03-11 16:18:18'),(2,'13800138002','123456','user2@qq.com','2026-03-11 16:18:18'),(3,'13800138003','123456','user3@qq.com','2026-03-11 16:18:18'),(4,'13800138004','123456','user4@qq.com','2026-03-11 16:18:18'),(5,'13800138005','123456','user5@qq.com','2026-03-11 16:18:18'),(6,'13800138006','123456','user6@qq.com','2026-03-11 16:18:18'),(7,'13800138007','123456','user7@qq.com','2026-03-11 16:18:18'),(8,'13800138008','123456','user8@qq.com','2026-03-11 16:18:18'),(9,'13800138009','123456','user9@qq.com','2026-03-11 16:18:18'),(10,'13800138010','123456','user10@qq.com','2026-03-11 16:18:18'),(11,'13800138011','123456','user11@qq.com','2026-03-11 16:18:18'),(12,'13800138012','123456','user12@qq.com','2026-03-11 16:18:18'),(13,'13800138013','123456','user13@qq.com','2026-03-11 16:18:18'),(14,'13800138014','123456','user14@qq.com','2026-03-11 16:18:18'),(15,'13800138015','123456','user15@qq.com','2026-03-11 16:18:18'),(16,'13800138016','123456','user16@qq.com','2026-03-11 16:18:18'),(17,'13800138017','123456','user17@qq.com','2026-03-11 16:18:18'),(18,'13800138018','123456','user18@qq.com','2026-03-11 16:18:18'),(19,'13800138019','123456','user19@qq.com','2026-03-11 16:18:18'),(20,'13800138020','123456','user20@qq.com','2026-03-11 16:18:18'),(21,'15039310535','12345678','user100@qq.com','2026-03-11 16:55:22'),(22,'15039310536','123456','user101@qq.com','2026-03-18 09:35:57');
/*!40000 ALTER TABLE `pigappusers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色类型（核心/专家/运营等）',
  `color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `perms` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '[]',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色定义表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'系统超级管理员','核心','#ff3b30','最高权限，配置所有功能','[\"dashboard_all\",\"user_all\",\"dietitian_all\",\"knowledge_all\",\"perm_all\",\"member_all\"]','2026-03-08 06:26:51','2026-03-08 06:26:51'),(2,'首席专家导师','专家','#5856d6','审核营养师、管理科普内容','[\"dashboard_view\",\"dietitian_audit\",\"knowledge_manage\",\"user_view\"]','2026-03-08 06:26:51','2026-03-08 06:26:51'),(3,'运营推广专员','运营','#34c759','管理会员、发布优惠券','[\"dashboard_view\",\"member_manage\",\"user_view\"]','2026-03-08 06:26:51','2026-03-08 06:26:51'),(4,'监控值班员','技术','#ff9500','监控系统、处理用户预警','[\"dashboard_view\",\"user_view\",\"system_monitor\"]','2026-03-08 06:26:51','2026-03-08 06:26:51');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `science_articles`
--

DROP TABLE IF EXISTS `science_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `science_articles` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分类标签：全部/暴食干预/营养知识/心理调节/运动指南',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章标题',
  `cover` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面图片',
  `desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '简介',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章正文（富文本）',
  `time` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '阅读时长',
  `like` int DEFAULT '0' COMMENT '点赞数',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='科普文章数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `science_articles`
--

LOCK TABLES `science_articles` WRITE;
/*!40000 ALTER TABLE `science_articles` DISABLE KEYS */;
INSERT INTO `science_articles` VALUES (1,'暴食干预','如何识别暴食发作的早期信号？','https://picsum.photos/800/450?random=1','暴食往往伴随着情绪失控，了解信号能帮你及时止损，走出饮食恶性循环。','<p>1. 情绪突然烦躁、焦虑，想用食物缓解压力</p><p>2. 明明不饿，但反复想吃东西，无法控制念头</p><p>3. 想独自待着，回避社交，只想待在有食物的地方</p><p>4. 呼吸变快、心跳加速，出现紧张生理反应</p><p><br></p><p>当你出现这些信号时，可以立刻：喝水、离开环境、深呼吸3分钟，能有效打断暴食冲动。</p>','5分钟',234,'2026-03-27 10:00:00'),(2,'暴食干预','暴食后愧疚感太强怎么办？','https://picsum.photos/800/450?random=2','暴食后的自责最伤人，学会接纳才能真正走出恶性循环。','<p>暴食后最可怕的不是吃多了，而是强烈的自我否定。</p><p><br></p><p>你可以这样做：</p><p>1. 告诉自己：一次暴食≠失败，不要过度惩罚自己</p><p>2. 不要节食“赎罪”，恢复正常三餐最重要</p><p>3. 记录情绪，找到真正让你暴食的根源（压力/孤独/疲惫）</p><p>4. 好好休息，第二天正常吃饭，打破恶性循环</p>','6分钟',198,'2026-03-27 10:01:00'),(3,'营养知识','三餐怎么吃最稳定食欲？','https://picsum.photos/800/450?random=3','科学搭配三餐，能让你不饿不馋，稳定血糖，减少暴食冲动。','<p>想减少暴食，核心是：稳定血糖 + 吃饱吃满足。</p><p><br></p><p>每一餐必须包含：</p><p>✅ 优质蛋白：鸡蛋、牛奶、瘦肉、豆腐</p><p>✅ 优质碳水：米饭、红薯、燕麦、全麦面包</p><p>✅ 大量蔬菜：补充纤维，延长饱腹感</p><p>✅ 少量健康脂肪：坚果、橄榄油、牛油果</p><p><br></p><p>只要吃对结构，你自然不会疯狂想吃零食。</p>','7分钟',320,'2026-03-27 10:02:00'),(4,'营养知识','喝水真的能抑制食欲吗？','https://picsum.photos/800/450?random=4','很多暴食都是“渴”出来的，正确喝水能大幅降低进食冲动。','<p>很多时候，我们分不清“口渴”和“饿”。</p><p><br></p><p>科学建议：</p><p>1. 想吃东西前，先喝200ml温水，等10分钟</p><p>2. 每天饮水量=体重kg×30ml</p><p>3. 不要等渴了再喝，保持规律喝水</p><p>4. 餐前喝水，能有效降低正餐暴食量</p>','4分钟',156,'2026-03-27 10:03:00'),(5,'心理调节','情绪性暴食怎么破？','https://picsum.photos/800/450?random=5','90%的暴食都不是因为饿，而是情绪在作怪。','<p>情绪性暴食：用吃来逃避压力、孤独、委屈、空虚。</p><p><br></p><p>三步解决：</p><p>1. 觉察：问自己“我真的饿吗？还是心里不舒服？”</p><p>2. 命名情绪：我现在是焦虑/生气/孤单/疲惫？</p><p>3. 替代行为：散步、听歌、洗澡、写日记、拥抱自己</p><p><br></p><p>食物只能暂时麻痹情绪，不能解决问题。</p>','8分钟',412,'2026-03-27 10:04:00'),(6,'心理调节','如何和自己的身体和解？','https://picsum.photos/800/450?random=6','停止讨厌自己的身体，是停止暴食的第一步。','<p>很多暴食来自：讨厌身体 → 节食 → 崩溃 → 暴食。</p><p><br></p><p>身体和解练习：</p><p>1. 每天夸自己身体一个优点</p><p>2. 不再用“胖/瘦”评判自己，而是用“舒服/健康”</p><p>3. 吃饭时专注感受食物，不批判自己</p><p>4. 接纳不完美，你值得被好好对待</p>','6分钟',289,'2026-03-27 10:05:00'),(7,'运动指南','不痛苦的运动也能降低暴食','https://picsum.photos/800/450?random=7','不用高强度，轻松运动就能稳定情绪、减少暴食。','<p>运动不是为了“赎罪”，而是为了让心情变好。</p><p><br></p><p>推荐低负担运动：</p><p>✅ 快走 20 分钟</p><p>✅ 拉伸 10 分钟</p><p>✅ 瑜伽 15 分钟</p><p>✅ 慢跑 10 分钟</p><p><br></p><p>运动能分泌多巴胺，让你不再想用食物获得快乐。</p>','5分钟',245,'2026-03-27 10:06:00'),(8,'运动指南','每天10分钟，改善饮食冲动','https://picsum.photos/800/450?random=8','碎片化运动，最适合容易暴食的人群。','<p>不需要去健身房，不需要大汗淋漓。</p><p><br></p><p>每日10分钟计划：</p><p>1. 早上：拉伸5分钟，唤醒身体</p><p>2. 晚上：快走5分钟，放松情绪</p><p>3. 暴食冲动来临时：原地踏步2分钟</p><p><br></p><p>小坚持，带来大改变。</p>','4分钟',173,'2026-03-27 10:07:00'),(9,'暴食干预','如何建立稳定的吃饭习惯？','https://picsum.photos/800/450?random=9','规律吃饭，是根治暴食最有效的方法。','<p>暴食的根源之一：不规律吃饭 → 血糖暴跌 → 失控暴食。</p><p><br></p><p>建立稳定习惯：</p><p>1. 三餐定时，不漏餐</p><p>2. 每餐吃到7-8分饱，不饿不撑</p><p>3. 不极端节食，允许自己吃喜欢的食物</p><p>4. 不在床上吃饭、不边看剧边狂吃</p>','7分钟',310,'2026-03-27 10:08:00'),(10,'营养知识','哪些食物最容易诱发暴食？','https://picsum.photos/800/450?random=10','不是你自制力差，而是有些食物会让人越吃越上瘾。','<p>这些食物容易触发暴食：</p><p>1. 高糖零食：蛋糕、奶茶、糖果</p><p>2. 精制碳水：白面包、饼干、膨化食品</p><p>3. 重油重盐：炸串、火锅、辣条</p><p><br></p><p>不是不能吃，而是要“有意识吃”，而不是失控吃。</p><p>了解诱因，才能更好保护自己。</p>','6分钟',266,'2026-03-27 10:09:00');
/*!40000 ALTER TABLE `science_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_admin`
--

DROP TABLE IF EXISTS `sys_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_admin`
--

LOCK TABLES `sys_admin` WRITE;
/*!40000 ALTER TABLE `sys_admin` DISABLE KEYS */;
INSERT INTO `sys_admin` VALUES (1,'admin','123456','超级管理员',NULL,1,1,'2026-03-05 18:53:54'),(2,'dietitian1','123456','张营养师',NULL,2,1,'2026-03-05 18:53:54'),(3,'operator1','123456','运营专员',NULL,3,1,'2026-03-05 18:53:54'),(4,'小王','123456',NULL,NULL,NULL,1,'2026-03-07 16:27:36'),(5,'陈泽毅猪猪','123456',NULL,NULL,NULL,1,'2026-11-09 19:50:53');
/*!40000 ALTER TABLE `sys_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'系统超级管理员','拥有所有权限'),(2,'营养师','只能查看和管理自己的用户'),(3,'运营人员','管理文章、数据统计');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_stat`
--

DROP TABLE IF EXISTS `sys_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `income` decimal(10,2) DEFAULT '0.00',
  `active_user` int DEFAULT '0',
  `convert_rate` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0%',
  `consume_weight` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0g',
  `member_total` int DEFAULT '0',
  `stat_date` date DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_stat`
--

LOCK TABLES `sys_stat` WRITE;
/*!40000 ALTER TABLE `sys_stat` DISABLE KEYS */;
INSERT INTO `sys_stat` VALUES (1,125.65,721,'89.9%','59.5g',499,'2026-03-04');
/*!40000 ALTER TABLE `sys_stat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `age` int DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `diet_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `active_score` int DEFAULT NULL,
  `dietitian_id` int DEFAULT NULL,
  `register_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'10001','刘备','13800138001','男',28,NULL,'正常','正常','热爱运动',82,0,'2026-03-06 15:25:49'),(2,'10002','关羽','13800138002','男',30,NULL,'暴食倾向','监控中','爱吃肉',65,1,'2026-03-06 15:25:49'),(3,'10003','张飞','13800138003','男',27,NULL,'轻度暴食','监控中','夜宵爱好者',70,1,'2026-03-06 15:25:49'),(4,'10004','赵云','13800138004','男',25,NULL,'正常','正常','健身达人',90,0,'2026-03-06 15:25:49'),(5,'10005','马超','13800138005','男',26,NULL,'正常','正常','规律饮食',85,0,'2026-03-06 15:25:49'),(6,'10006','黄忠','13800138006','男',50,NULL,'正常','正常','清淡饮食',78,0,'2026-03-06 15:25:49'),(7,'10007','诸葛亮','13800138007','男',29,NULL,'正常','正常','作息规律',95,0,'2026-03-06 15:25:49'),(8,'10008','周瑜','13800138008','男',27,NULL,'暴食预警','重点关注','压力大',58,2,'2026-03-06 15:25:49'),(9,'10009','吕布','13800138009','男',28,NULL,'轻度暴食','监控中','暴饮暴食',66,1,'2026-03-06 15:25:49'),(10,'10010','貂蝉','13800138010','女',22,NULL,'正常','正常','养生',88,0,'2026-03-06 15:25:49'),(11,'10011','小乔','13800138011','女',21,NULL,'正常','正常','爱吃水果',92,0,'2026-03-06 15:25:49'),(12,'10012','大乔','13800138012','女',23,NULL,'正常','正常','健康饮食',89,0,'2026-03-06 15:25:49'),(13,'10013','甄姬','13800138013','女',24,NULL,'暴食倾向','监控中','甜食爱好者',60,1,'2026-03-06 15:25:49'),(14,'10014','孙尚香','13800138014','女',22,NULL,'正常','正常','运动少女',94,0,'2026-03-06 15:25:49'),(15,'10015','黄月英','13800138015','女',26,NULL,'正常','正常','素食',80,0,'2026-03-06 15:25:49'),(16,'10016','曹操','13800138016','男',35,NULL,'轻度暴食','监控中','爱吃油炸',68,1,'2026-03-06 15:25:49'),(17,'10017','司马懿','13800138017','男',33,NULL,'正常','正常','饮食规律',86,0,'2026-03-06 15:25:49'),(18,'10018','张辽','13800138018','男',29,NULL,'正常','正常','健身',84,0,'2026-03-06 15:25:49'),(19,'10019','徐晃','13800138019','男',31,NULL,'暴食倾向','监控中','夜宵',62,1,'2026-03-06 15:25:49'),(20,'10020','许褚','13800138020','男',28,NULL,'轻度暴食','监控中','爱吃肉',71,1,'2026-03-06 15:25:49'),(21,'10021','典韦','13800138021','男',27,NULL,'正常','正常','运动',81,0,'2026-03-06 15:25:49'),(22,'10022','郭嘉','13800138022','男',28,NULL,'暴食预警','重点关注','熬夜',55,2,'2026-03-06 15:25:49'),(23,'10023','荀彧','13800138023','男',36,NULL,'正常','正常','清淡',87,0,'2026-03-06 15:25:49'),(24,'10024','陆逊','13800138024','男',25,NULL,'正常','正常','健康',91,0,'2026-03-06 15:25:49'),(25,'10025','吕蒙','13800138025','男',27,NULL,'轻度暴食','监控中','外卖',69,1,'2026-03-06 15:25:49'),(26,'10026','甘宁','13800138026','男',26,NULL,'正常','正常','健身',83,0,'2026-03-06 15:25:49'),(27,'10027','太史慈','13800138027','男',29,NULL,'正常','正常','规律',85,0,'2026-03-06 15:25:49'),(28,'10028','周泰','13800138028','男',30,NULL,'暴食倾向','监控中','夜宵',64,1,'2026-03-06 15:25:49'),(29,'10029','凌统','13800138029','男',24,NULL,'正常','正常','运动',93,0,'2026-03-06 15:25:49'),(30,'10030','程普','13800138030','男',45,NULL,'正常','正常','养生',79,0,'2026-03-06 15:25:49'),(31,'10031','马岱','13800138031','男',25,NULL,'正常','正常','饮食规律',88,0,'2026-03-06 15:25:49'),(32,'10032','魏延','13800138032','男',32,NULL,'轻度暴食','监控中','暴饮暴食',67,1,'2026-03-06 15:25:49'),(33,'10033','庞统','13800138033','男',34,NULL,'暴食预警','重点关注','压力大',56,2,'2026-03-06 15:25:49'),(34,'10034','徐庶','13800138034','男',28,NULL,'正常','正常','素食',82,0,'2026-03-06 15:25:49'),(35,'10035','法正','13800138035','男',30,NULL,'正常','正常','清淡',84,0,'2026-03-06 15:25:49'),(36,'10036','严颜','13800138036','男',52,NULL,'正常','正常','养生',76,0,'2026-03-06 15:25:49'),(37,'10037','李严','13800138037','男',38,NULL,'暴食倾向','监控中','爱吃肉',63,1,'2026-03-06 15:25:49'),(38,'10038','陈到','13800138038','男',27,NULL,'正常','正常','健身',90,0,'2026-03-06 15:25:49'),(39,'10039','关平','13800138039','男',22,NULL,'正常','正常','运动',92,0,'2026-03-06 15:25:49'),(40,'10040','张苞','13800138040','男',21,NULL,'轻度暴食','监控中','夜宵',68,1,'2026-03-06 15:25:49'),(41,'10041','关兴','13800138041','男',20,NULL,'正常','正常','健康',94,0,'2026-03-06 15:25:49'),(42,'10042','张翼','13800138042','男',28,NULL,'正常','正常','规律',85,0,'2026-03-06 15:25:49'),(43,'10043','廖化','13800138043','男',40,NULL,'正常','正常','养生',77,0,'2026-03-06 15:25:49'),(44,'10044','王平','13800138044','男',26,NULL,'暴食倾向','监控中','外卖',61,1,'2026-03-06 15:25:49'),(45,'10045','马忠','13800138045','男',27,NULL,'正常','正常','健身',86,0,'2026-03-06 15:25:49'),(46,'10046','张嶷','13800138046','男',33,NULL,'轻度暴食','监控中','暴饮暴食',70,1,'2026-03-06 15:25:49'),(47,'10047','吴懿','13800138047','男',35,NULL,'正常','正常','清淡',83,0,'2026-03-06 15:25:49'),(48,'10048','吴班','13800138048','男',31,NULL,'正常','正常','运动',89,0,'2026-03-06 15:25:49'),(49,'10049','傅彤','13800138049','男',29,NULL,'暴食预警','重点关注','熬夜',54,2,'2026-03-06 15:25:49'),(50,'10050','冯习','13800138050','男',28,NULL,'正常','正常','饮食规律',81,0,'2026-03-06 15:25:49'),(51,'10051','沙摩柯','13800138051','男',30,NULL,'轻度暴食','监控中','爱吃肉',69,1,'2026-03-06 15:25:49'),(52,'10052','兀突骨','13800138052','男',32,NULL,'正常','正常','健身',87,0,'2026-03-06 15:25:49'),(53,'10053','孟获','13800138053','男',29,NULL,'正常','正常','运动',90,0,'2026-03-06 15:25:49'),(54,'10054','祝融','13800138054','女',26,NULL,'正常','正常','健康',91,0,'2026-03-06 15:25:49'),(55,'10055','带来洞主','13800138055','男',25,NULL,'暴食倾向','监控中','夜宵',62,1,'2026-03-06 15:25:49'),(56,'10056','董荼那','13800138056','男',27,NULL,'正常','正常','规律',84,0,'2026-03-06 15:25:49'),(57,'10057','阿会喃','13800138057','男',26,NULL,'轻度暴食','监控中','外卖',66,1,'2026-03-06 15:25:49'),(58,'10058','金环三结','13800138058','男',28,NULL,'正常','正常','健身',85,0,'2026-03-06 15:25:49'),(59,'10059','忙牙长','13800138059','男',22,NULL,'正常','正常','运动',93,0,'2026-03-06 15:25:49'),(60,'10060','杨锋','13800138060','男',34,NULL,'正常','正常','养生',78,0,'2026-03-06 15:25:49'),(61,'10061','朵思大王','13800138061','男',31,NULL,'暴食倾向','监控中','甜食',60,1,'2026-03-06 15:25:49'),(62,'10062','木鹿大王','13800138062','男',33,NULL,'正常','正常','清淡',82,0,'2026-03-06 15:25:49'),(63,'10063','刘巴','13800138063','男',40,NULL,'正常','正常','素食',80,0,'2026-03-06 15:25:49'),(64,'10064','法正','13800138064','男',32,NULL,'轻度暴食','监控中','压力大',65,1,'2026-03-06 15:25:49'),(65,'10065','李恢','13800138065','男',36,NULL,'正常','正常','健康',88,0,'2026-03-06 15:25:49'),(66,'10066','吕凯','13800138066','男',27,NULL,'正常','正常','规律',86,0,'2026-03-06 15:25:49'),(67,'10067','王伉','13800138067','男',29,NULL,'暴食预警','重点关注','熬夜',57,2,'2026-03-06 15:25:49'),(68,'10068','雍闿','13800138068','男',30,NULL,'轻度暴食','监控中','暴饮暴食',68,1,'2026-03-06 15:25:49'),(69,'10069','朱褒','13800138069','男',28,NULL,'正常','正常','健身',84,0,'2026-03-06 15:25:49'),(70,'10070','高定','13800138070','男',32,NULL,'正常','正常','运动',89,0,'2026-03-06 15:25:49'),(71,'10071','鄂焕','13800138071','男',26,NULL,'暴食倾向','监控中','夜宵',63,1,'2026-03-06 15:25:49'),(72,'10072','金旋','13800138072','男',38,NULL,'正常','正常','养生',75,0,'2026-03-06 15:25:49'),(73,'10073','韩玄','13800138073','男',45,NULL,'正常','正常','清淡',76,0,'2026-03-06 15:25:49'),(74,'10074','刘度','13800138074','男',42,NULL,'正常','正常','素食',77,0,'2026-03-06 15:25:49'),(75,'10075','赵范','13800138075','男',33,NULL,'轻度暴食','监控中','外卖',67,1,'2026-03-06 15:25:49'),(76,'10076','陈应','13800138076','男',27,NULL,'正常','正常','健身',85,0,'2026-03-06 15:25:49'),(77,'10077','鲍隆','13800138077','男',28,NULL,'正常','正常','运动',90,0,'2026-03-06 15:25:49'),(78,'10078','邢道荣','13800138078','男',30,NULL,'暴食倾向','监控中','爱吃肉',64,1,'2026-03-06 15:25:49'),(79,'10079','杨龄','13800138079','男',26,NULL,'正常','正常','规律',83,0,'2026-03-06 15:25:49'),(80,'10080','巩志','13800138080','男',29,NULL,'正常','正常','健康',87,0,'2026-03-06 15:25:49'),(81,'10081','邓贤','13800138081','男',25,NULL,'轻度暴食','监控中','夜宵',62,1,'2026-03-06 15:25:49'),(82,'10082','冷苞','13800138082','男',27,NULL,'正常','正常','健身',88,0,'2026-03-06 15:25:49'),(83,'10083','张任','13800138083','男',30,NULL,'正常','正常','运动',92,0,'2026-03-06 15:25:49'),(84,'10084','刘璝','13800138084','男',28,NULL,'暴食倾向','监控中','外卖',61,1,'2026-03-06 15:25:49'),(85,'10085','卓膺','13800138085','男',26,NULL,'正常','正常','规律',84,0,'2026-03-06 15:25:49'),(86,'10086','费观','13800138086','男',31,NULL,'正常','正常','清淡',85,0,'2026-03-06 15:25:49'),(87,'10087','吴兰','13800138087','男',29,NULL,'轻度暴食','监控中','暴饮暴食',69,1,'2026-03-06 15:25:49'),(88,'10088','雷铜','13800138088','男',27,NULL,'正常','正常','健身',86,0,'2026-03-06 15:25:49'),(89,'10089','任夔','13800138089','男',24,NULL,'正常','正常','运动',91,0,'2026-03-06 15:25:49'),(90,'10090','侯选','13800138090','男',32,NULL,'轻度暴食','监控中','夜宵',60,1,'2026-03-06 15:25:49'),(91,'10091','程银','13800138091','男',30,NULL,'正常','正常','规律',82,0,'2026-03-06 15:25:49'),(92,'10092','李堪','13800138092','男',28,NULL,'正常','正常','健康',89,0,'2026-03-06 15:25:49'),(93,'10093','张横','13800138093','男',27,NULL,'轻度暴食','监控中','外卖',66,1,'2026-03-06 15:25:49'),(94,'10094','成宜','13800138094','男',25,NULL,'正常','正常','健身',87,0,'2026-03-06 15:25:49'),(95,'10095','马玩','13800138095','男',26,NULL,'正常','正常','运动',90,0,'2026-03-06 15:25:49'),(96,'10096','梁兴','13800138096','男',29,NULL,'轻度暴食','监控中','甜食',59,1,'2026-03-06 15:25:49'),(97,'10097','杨秋','13800138097','男',27,NULL,'正常','正常','清淡',84,0,'2026-03-06 15:25:49'),(98,'10098','蒋钦','13800138098','男',31,NULL,'正常','正常','素食',81,0,'2026-03-06 15:25:49');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '#555555',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'暴食','#e8251a','2026-03-06 00:04:24','2026-03-06 00:04:24'),(2,'心理健康','#7a5ea8','2026-03-06 00:04:24','2026-03-06 00:04:24'),(3,'食谱','#6a8a3a','2026-03-06 00:04:24','2026-03-06 00:04:24'),(4,'营养学','#a07040','2026-03-06 00:04:24','2026-03-06 00:04:24'),(5,'正念','#3a8a5a','2026-03-06 00:04:24','2026-03-06 00:04:24');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_profile`
--

DROP TABLE IF EXISTS `user_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_profile` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `alias` varchar(50) DEFAULT NULL COMMENT '昵称/代号（建立个人档案页）',
  `gender` varchar(10) DEFAULT NULL COMMENT '性别（基础信息页）',
  `age` int DEFAULT NULL COMMENT '年龄（基础信息页）',
  `height` float DEFAULT NULL COMMENT '身高（基础信息页）',
  `weight` float DEFAULT NULL COMMENT '体重（基础信息页）',
  `bmi` float DEFAULT NULL COMMENT 'BMI指数（基础信息页）',
  `sports_type` varchar(50) DEFAULT NULL COMMENT '运动偏好（运动基准页）',
  `sports_freq` varchar(20) DEFAULT NULL COMMENT '运动频率（运动基准页）',
  `diet_addiction` varchar(255) DEFAULT NULL COMMENT '高危成瘾项（饮食习惯页）',
  `takeout_freq` varchar(20) DEFAULT NULL COMMENT '外卖依赖程度（饮食习惯页）',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户健康信息总表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_profile`
--

LOCK TABLES `user_profile` WRITE;
/*!40000 ALTER TABLE `user_profile` DISABLE KEYS */;
INSERT INTO `user_profile` VALUES (1,'小肥','女',21,163,58,21.8,'柔韧型','1-3次','液体糖分,精致碳水','偶尔点','2026-03-12 16:06:28'),(2,'健身狂人','男',24,178,72,22.7,'耐力型','4-6次','无','几乎不买','2026-03-12 16:06:28'),(3,'干饭王','男',26,172,85,28.7,'久坐族','0次','重油重盐,深夜进食','几乎每天','2026-03-12 16:06:28'),(4,'奶茶星人','女',22,158,52,20.8,'久坐族','1-3次','液体糖分,精致碳水','经常点','2026-03-12 16:06:28'),(5,'自律小天使','女',23,165,49,18.1,'耐力型','每天','无','几乎不买','2026-03-12 16:06:28'),(6,'夜宵冠军','男',28,175,90,29.4,'力量型','1-3次','重油重盐,深夜进食','经常点','2026-03-12 16:06:28'),(7,'小瘦子','女',20,166,45,16.3,'柔韧型','1-3次','精致碳水','偶尔点','2026-03-12 16:06:28'),(8,'健康达人','男',30,180,76,23.5,'力量型','4-6次','无','几乎不买','2026-03-12 16:06:28'),(9,'加班狗','女',25,160,56,21.9,'久坐族','0次','深夜进食,液体糖分','几乎每天','2026-03-12 16:06:28'),(10,'美食爱好者','男',27,173,80,26.7,'耐力型','1-3次','重油重盐','经常点','2026-03-12 16:06:28'),(11,'如意','female',18,167,50,17.9,'耐力型、力量型','4-6次','液体糖分、精致碳水、重油重盐','偶尔点','2026-03-12 17:24:19'),(12,'如意','female',18,167,50,17.9,'耐力型、力量型','4-6次','液体糖分、重油重盐、精致碳水','偶尔点','2026-03-12 17:30:25'),(13,'如意','female',18,167,50,17.9,'耐力型、力量型','4-6次','液体糖分、重油重盐、精致碳水','经常点','2026-03-12 17:43:48'),(14,'如意','female',18,167,50,17.9,'耐力型、力量型','4-6次','液体糖分、精致碳水','经常点','2026-03-12 19:23:10'),(15,'如意','female',18,167,60,21.5,'力量型、耐力型','4-6次','液体糖分、重油重盐、精致碳水','经常点','2026-03-13 15:21:08'),(16,'如意','female',18,167,57,20.4,'力量型、耐力型、柔韧型','4-6次','液体糖分、重油重盐、精致碳水','经常点','2026-03-13 18:28:23'),(17,'.','female',18,167,50,17.9,'力量型、耐力型、柔韧型','4-6次','液体糖分、重油重盐、精致碳水','经常点','2026-03-13 18:54:05'),(18,'晓萍','female',18,180,60,18.5,'耐力型、力量型、柔韧型','4-6次','液体糖分、重油重盐、精致碳水','经常点','2026-03-14 09:32:59'),(19,'.。','女',18,167,60,21.5,'endurance,strength','0','liquidSugar,heavyOilSalt','often','2026-03-21 11:22:04'),(20,'如意大王','女',18,168,60,21.3,'endurance,strength','0','liquidSugar,heavyOilSalt','often','2026-03-21 11:48:44'),(21,'.。。','女',16,167,60,21.5,'endurance,strength','0','liquidSugar','often','2026-03-21 11:53:37'),(22,'小如意','女',18,167,60,21.5,'耐力型、力量型','0次','液体糖分、重油重盐','经常点','2026-03-21 12:00:41'),(23,'.。','女',18,167,60,21.5,'耐力型、力量型','4-6次','液体糖分、重油重盐','经常点','2026-03-21 13:09:29'),(24,'.。','男',18,175,60,19.6,'耐力型','0次','液体糖分','经常点','2026-03-21 13:25:14'),(25,'.。','女',18,167,60,21.5,'耐力型','0次','液体糖分','经常点','2026-03-27 13:53:41'),(26,'2','女',16,180,60,18.5,'耐力型','0次','液体糖分','经常点','2026-03-27 13:55:50'),(27,'x','女',18,167,60,21.5,'耐力型','0次','液体糖分','经常点','2026-03-27 14:00:25'),(28,'b','女',18,167,60,21.5,'耐力型','0次','液体糖分','经常点','2026-03-27 14:01:47'),(29,'b','女',18,167,60,21.5,'耐力型','0次','液体糖分','经常点','2026-03-27 14:01:52'),(30,'n','女',18,167,60,21.5,'耐力型','0次','液体糖分','经常点','2026-03-27 14:02:11'),(31,'巴巴','女',16,167,60,21.5,'耐力型、力量型','0次','液体糖分、重油重盐','经常点','2026-03-27 15:51:27'),(32,'，，','女',16,167,60,21.5,'耐力型、力量型','0次','液体糖分、重油重盐','经常点','2026-03-27 18:33:48'),(33,'.。','男',16,167,60,21.5,'耐力型','0次','液体糖分','经常点','2026-03-27 18:52:05'),(34,'，，','女',16,167,60,21.5,'耐力型、力量型','4-6次','液体糖分、重油重盐','经常点','2026-03-27 19:22:59');
/*!40000 ALTER TABLE `user_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'bcrypt 加密后的密码',
  `display_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '前端显示名称',
  `role` enum('admin','editor','reviewer') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'editor' COMMENT 'admin=超级管理员, editor=编辑/营养师, reviewer=审核员',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2a$10$8B7BYs3m1vY4ZvoIrW5s5OJUEGlOlHJDdSER82yNTEjgj9XR2VElq','Admin_PC','admin','2026-03-06 00:04:24','2026-03-06 00:04:24'),(2,'dr_chen','$2a$10$7yRZBDzwoInMYWglQVOhE.kaRRwJ4JJ93wkXCnAlyKaRfZMtIaF2u','Dr.陈晓燕','editor','2026-03-06 00:04:24','2026-03-06 00:04:24'),(3,'nutritionist','$2a$10$7yRZBDzwoInMYWglQVOhE.kaRRwJ4JJ93wkXCnAlyKaRfZMtIaF2u','营养助手','editor','2026-03-06 00:04:24','2026-03-06 00:04:24'),(4,'reviewer','$2a$10$7yRZBDzwoInMYWglQVOhE.kaRRwJ4JJ93wkXCnAlyKaRfZMtIaF2u','李营养师','reviewer','2026-03-06 00:04:24','2026-03-06 00:04:24'),(5,'佳怡','$2a$10$C8mCNQTXV66M9iOq6zYBtuEpMlRBaPwSR/FyQQIY7/4BIxH7jD4LW','佳怡','editor','2026-03-11 18:32:48','2026-03-11 18:32:48'),(6,'佳怡一页','$2a$10$x2W7pwrIg//y8I1mJkrLK.HLie/Lwg5yZvXDh7j1wMTLDE8IeWFDq','佳怡','editor','2026-03-11 18:38:48','2026-03-11 18:38:48');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-10 10:37:21
