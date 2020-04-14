-- MySQL dump 10.13  Distrib 8.0.18, for osx10.15 (x86_64)
--
-- Host: localhost    Database: netrigger
-- ------------------------------------------------------
-- Server version	8.0.15

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
-- Table structure for table `CollectionCrwalset`
--

DROP TABLE IF EXISTS `CollectionCrwalset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CollectionCrwalset` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `crawlsetId` int(11) NOT NULL,
  `collectionId` int(11) NOT NULL,
  PRIMARY KEY (`crawlsetId`,`collectionId`),
  KEY `collectionId` (`collectionId`),
  CONSTRAINT `collectioncrwalset_ibfk_1` FOREIGN KEY (`crawlsetId`) REFERENCES `crawlsets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `collectioncrwalset_ibfk_2` FOREIGN KEY (`collectionId`) REFERENCES `collections` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CollectionCrwalset`
--

LOCK TABLES `CollectionCrwalset` WRITE;
/*!40000 ALTER TABLE `CollectionCrwalset` DISABLE KEYS */;
/*!40000 ALTER TABLE `CollectionCrwalset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collections`
--

DROP TABLE IF EXISTS `collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `private` tinyint(1) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collections`
--

LOCK TABLES `collections` WRITE;
/*!40000 ALTER TABLE `collections` DISABLE KEYS */;
INSERT INTO `collections` VALUES (2,'test',0,'2019-12-11 19:12:12','2019-12-11 19:12:12',NULL);
/*!40000 ALTER TABLE `collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crawlsets`
--

DROP TABLE IF EXISTS `crawlsets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crawlsets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `selector` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crawlsets`
--

LOCK TABLES `crawlsets` WRITE;
/*!40000 ALTER TABLE `crawlsets` DISABLE KEYS */;
/*!40000 ALTER TABLE `crawlsets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `keywords`
--

DROP TABLE IF EXISTS `keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `keywords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kryword` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kryword` (`kryword`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `keywords`
--

LOCK TABLES `keywords` WRITE;
/*!40000 ALTER TABLE `keywords` DISABLE KEYS */;
/*!40000 ALTER TABLE `keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metadata`
--

DROP TABLE IF EXISTS `metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metadata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(300) COLLATE utf8mb4_general_ci NOT NULL,
  `url` varchar(300) COLLATE utf8mb4_general_ci NOT NULL,
  `site` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `updated_time` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `local` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `OGcontent` int(11) DEFAULT NULL,
  `post_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  UNIQUE KEY `description` (`description`),
  UNIQUE KEY `image` (`image`),
  UNIQUE KEY `url` (`url`),
  UNIQUE KEY `site` (`site`),
  UNIQUE KEY `updated_time` (`updated_time`),
  UNIQUE KEY `local` (`local`),
  KEY `OGcontent` (`OGcontent`),
  KEY `post_id` (`post_id`),
  CONSTRAINT `metadata_ibfk_1` FOREIGN KEY (`OGcontent`) REFERENCES `crawlsets` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `metadata_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metadata`
--

LOCK TABLES `metadata` WRITE;
/*!40000 ALTER TABLE `metadata` DISABLE KEYS */;
/*!40000 ALTER TABLE `metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostCollection`
--

DROP TABLE IF EXISTS `PostCollection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PostCollection` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `postId` int(11) NOT NULL,
  `collectionId` int(11) NOT NULL,
  PRIMARY KEY (`postId`,`collectionId`),
  KEY `collectionId` (`collectionId`),
  CONSTRAINT `postcollection_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `postcollection_ibfk_2` FOREIGN KEY (`collectionId`) REFERENCES `collections` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PostCollection`
--

LOCK TABLES `PostCollection` WRITE;
/*!40000 ALTER TABLE `PostCollection` DISABLE KEYS */;
INSERT INTO `PostCollection` VALUES ('2019-12-12 05:02:34','2019-12-12 05:02:34',4,2),('2019-12-12 05:55:35','2019-12-12 05:55:35',5,2),('2019-12-12 14:34:21','2019-12-12 14:34:21',6,2),('2019-12-12 16:10:20','2019-12-12 16:10:20',7,2),('2019-12-12 16:28:38','2019-12-12 16:28:38',8,2),('2019-12-14 12:35:23','2019-12-14 12:35:23',9,2),('2019-12-14 12:35:23','2019-12-14 12:35:23',10,2),('2019-12-14 13:30:43','2019-12-14 13:30:43',11,2),('2019-12-14 14:28:48','2019-12-14 14:28:48',12,2),('2019-12-15 16:55:59','2019-12-15 16:55:59',13,2),('2019-12-15 17:45:05','2019-12-15 17:45:05',14,2),('2019-12-15 19:01:26','2019-12-15 19:01:26',15,2),('2019-12-15 19:01:26','2019-12-15 19:01:26',16,2),('2019-12-16 16:01:19','2019-12-16 16:01:19',17,2),('2019-12-16 16:01:19','2019-12-16 16:01:19',18,2),('2019-12-16 17:30:48','2019-12-16 17:30:48',19,2),('2019-12-17 13:46:39','2019-12-17 13:46:39',20,2),('2019-12-17 13:46:39','2019-12-17 13:46:39',21,2),('2019-12-17 17:57:32','2019-12-17 17:57:32',22,2),('2019-12-18 16:38:55','2019-12-18 16:38:55',23,2),('2019-12-18 16:38:55','2019-12-18 16:38:55',24,2);
/*!40000 ALTER TABLE `PostCollection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostCr`
--

DROP TABLE IF EXISTS `PostCr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PostCr` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `postId` int(11) NOT NULL,
  `crawlsetId` int(11) NOT NULL,
  PRIMARY KEY (`postId`,`crawlsetId`),
  KEY `crawlsetId` (`crawlsetId`),
  CONSTRAINT `postcr_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `postcr_ibfk_2` FOREIGN KEY (`crawlsetId`) REFERENCES `crawlsets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PostCr`
--

LOCK TABLES `PostCr` WRITE;
/*!40000 ALTER TABLE `PostCr` DISABLE KEYS */;
/*!40000 ALTER TABLE `PostCr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostCrwa`
--

DROP TABLE IF EXISTS `PostCrwa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PostCrwa` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `crawlsetId` int(11) NOT NULL,
  `postId` int(11) NOT NULL,
  PRIMARY KEY (`crawlsetId`,`postId`),
  KEY `postId` (`postId`),
  CONSTRAINT `postcrwa_ibfk_1` FOREIGN KEY (`crawlsetId`) REFERENCES `crawlsets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `postcrwa_ibfk_2` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PostCrwa`
--

LOCK TABLES `PostCrwa` WRITE;
/*!40000 ALTER TABLE `PostCrwa` DISABLE KEYS */;
/*!40000 ALTER TABLE `PostCrwa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostCrwal`
--

DROP TABLE IF EXISTS `PostCrwal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PostCrwal` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `crawlsetId` int(11) NOT NULL,
  `postId` int(11) NOT NULL,
  PRIMARY KEY (`crawlsetId`,`postId`),
  KEY `postId` (`postId`),
  CONSTRAINT `postcrwal_ibfk_1` FOREIGN KEY (`crawlsetId`) REFERENCES `crawlsets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `postcrwal_ibfk_2` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PostCrwal`
--

LOCK TABLES `PostCrwal` WRITE;
/*!40000 ALTER TABLE `PostCrwal` DISABLE KEYS */;
/*!40000 ALTER TABLE `PostCrwal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostCrwalset`
--

DROP TABLE IF EXISTS `PostCrwalset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PostCrwalset` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `postId` int(11) NOT NULL,
  `crawlsetId` int(11) NOT NULL,
  PRIMARY KEY (`postId`,`crawlsetId`),
  KEY `crawlsetId` (`crawlsetId`),
  CONSTRAINT `postcrwalset_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `postcrwalset_ibfk_2` FOREIGN KEY (`crawlsetId`) REFERENCES `crawlsets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PostCrwalset`
--

LOCK TABLES `PostCrwalset` WRITE;
/*!40000 ALTER TABLE `PostCrwalset` DISABLE KEYS */;
/*!40000 ALTER TABLE `PostCrwalset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostKeyword`
--

DROP TABLE IF EXISTS `PostKeyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PostKeyword` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `postId` int(11) NOT NULL,
  `keywordId` int(11) NOT NULL,
  PRIMARY KEY (`postId`,`keywordId`),
  KEY `keywordId` (`keywordId`),
  CONSTRAINT `postkeyword_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `postkeyword_ibfk_2` FOREIGN KEY (`keywordId`) REFERENCES `keywords` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PostKeyword`
--

LOCK TABLES `PostKeyword` WRITE;
/*!40000 ALTER TABLE `PostKeyword` DISABLE KEYS */;
/*!40000 ALTER TABLE `PostKeyword` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `image` varchar(300) COLLATE utf8mb4_general_ci NOT NULL,
  `url` varchar(300) COLLATE utf8mb4_general_ci NOT NULL,
  `site` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `updated_time` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `local` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (4,'애초에 \'기다리는 동안\' 기능 자체가 웃긴데 - 겐지 갤러리','식당 회전률 높일 생각은 없고 손님들 줄 서 계신동안 뾱뾱이라도 터뜨리면서 기다리라고 던져주는 기능','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1054c6830f1d10052f39513862679eb29f40686c92ced232ead9e1e983f89364882b1912b83c520ed37327464c509cbe3930aa83221d9b9bc14c09f1263a41009eddf3eb745204c95b07','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1091777&exception_mode=recommend&page=1','디시인사이드','2019-12-12 03:02:31','ko_KR'),(5,'OKKY | [펌] 다가오는 2020년 프로그래밍 트렌드 (언어)',' 다른 사람들 보다 먼저 진입해서 배워두면 좋을 유망한 기술을 알아보다가 보게 된 글입니다.  저는 Rust, Progressive Web Apps에 관심이 가더라구요.      2020년 어떤 프로그래밍 언어를 배워야 할까?      관심있는 분은 참고바랍니다. ','//okky.kr/assets/okky_logo_fb-cea175ff727ef14a4d8be0e68cff730a.png','https://okky.kr/article/659487','OKKY','2019-12-11 11:29:52',''),(6,'생각해보니 이 병신게임회사 욕해도 정지임 - 겐지 갤러리','ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ ','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1054c6830f1d10052f3951326e639fbd9c416d62806e158af246ee05d0999779205d2dd25e7062ff64c5efd378f977eca726d401f4dcec8f1e0e56ad4e965afb6392d3d41bff7b8904d2bab22d02f6c7','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1092173&exception_mode=recommend&page=1','디시인사이드','2019-12-12 12:18:26','ko_KR'),(7,'시그마 여전히 좋음 1티어임 - 겐지 갤러리','딜량이 너무좋고 강착으로 원콤도 낼수있음 방벽을 예전처럼 막쓰지말고 풀피일땐 무빙으로 피하다가 100정도 까이면 방벽깔고 하는식으로 그리고 방벽회수 자주해서 방벽 자주채우고 하면 여전히 좋음 ','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1054c6830f1d10052f39513968669db59345696d73bf42765f08ab132d432f0fd461400ac001d4ff87cbd322c6bc9afa15ff943050f5ca3aa7edf483f3b1db523f0ef928','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1092491&exception_mode=recommend&page=1','디시인사이드','2019-12-12 16:00:35','ko_KR'),(8,'메이 새 버그 떴다ㅋㅋㅋㅋㅋㅋ - 겐지 갤러리','모든 캐릭이 삐딱하게 날수있음ㅋㅋㅋ','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1054c6830f1d10052f3951326c6498b19e456e62586117c3cfdce6c4b0efdab0ab11f6d58bae5202b2f66aad12c48e7a61c2a6e261784bb5b30fb5aacbb98563e49225e04b1067b1afdc','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1092509&exception_mode=recommend&page=1','디시인사이드','2019-12-12 16:14:03','ko_KR'),(9,'윈스턴 미러전.gif - 겐지 갤러리','국내 최대 커뮤니티 포털 디시인사이드. 힛갤러리, 유저이슈 등 인터넷 트렌드 총 집합','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1052c6837d0a7a61b8f674890ba4b05c287bb33c79da56c46ac88886ffadd4e7d559ee52a0','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1095636&exception_mode=recommend&page=1','디시인사이드','2019-12-14 11:34:19','ko_KR'),(10,'OKKY | 요기요, 국내 배달앱 1위 배달의민족 인수',' http://m.zdnet.co.kr/news_view.asp?article_id 20191213115846 re zdk#imadnews           관심있는 분은 참고바랍니다. ','//okky.kr/assets/okky_logo_fb-cea175ff727ef14a4d8be0e68cff730a.png','https://okky.kr/article/660662','OKKY','2019-12-13 14:03:39',''),(11,'Leonmaster 라는 유튜버의 리그팀 티어정리 - 겐지 갤러리','숔 탱s 딜s 힐s 밴 탱a 딜s 힐s 뇩 탱s 딜s,a 힐s 항 탱a 딜b 힐b 글 탱s 딜d 힐a 틀 탱s 딜s 힐a 런 탱b 딜c 힐c 설 탱a 딜a 힐b 광 탱b 딜b 힐a 필 탱a 딜b 힐b 상 탱a 딜s 힐','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1052c6837d0a7a61b8f6748b04aab6582e7eb032ccbb4e46e0c8e3f1814c64726bd26e50211b019155e126f94e8a564d5fb72eaa3045d33df642fa4ca0fd068683c7c5697a85d7d8fa999bfd1a','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1095696&exception_mode=recommend&page=1','디시인사이드','2019-12-14 12:15:51','ko_KR'),(12,'시발 결국 김좆태 땜에 핵 많아진거 맞네 - 겐지 갤러리','ㅅㅂ 이래놓고 지는 핵 유저 근멸 어쩌고 저쩌구~이 새끼 ㅇ우리원 까는것도 그렇고핵조지는 거보다 어그로 ㅈㄴ 끌어서 조회수 일단 처 빠는게 본 목적일걸어느 병신이 핵 근절하고 싶은데 판매처등 자세히 알려주냐 ','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1052c6837d0a7a61b8f674880da9b45a2e7cbf3c2f30f079ac9a01283aa349aeaabc801f6abbff34a75a8bc4db845a864d6a9dd80fb33d465f15990236894191055f67f59797de1d61ba40','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1095812&exception_mode=recommend&page=1','디시인사이드','2019-12-14 13:55:04','ko_KR'),(13,'\'\'이봐.\'\' - 겐지 갤러리','그립나?  - dc official App','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1053c683a879b0fd07a19814f253f1b4016d9aaf042214cc26b22cc6a1f48eb5443b26d9955f7daa8794675987edda4d2998432bb8131ea0ad43d54a','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1097620&exception_mode=recommend&page=1','디시인사이드','2019-12-15 03:10:34','ko_KR'),(14,'충격 주의)미로가 메르시 따던 짤의 진실 - 겐지 갤러리','미로를 대표하는 시그니쳐 짤이자 현재까지도 회자되는 명짤 사실 빛ㅂ제홍이 양념 다 쳐놓은거 ㄹㅇ 그와중에 비트쓰는 루시우 잡음 ㄹㅇ; ','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1053c683a879b0fd07a19815fe53f4b3036a9fafe5e861b0ead2d74df58faac30a4304cb1a0dc5e064a030be360b241a','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1098547&exception_mode=recommend&page=1','디시인사이드','2019-12-15 16:39:25','ko_KR'),(15,'도월양 옵치한판만화 -방벽패치- - 겐지 갤러리','http://naver.me/x84U6z34 ','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1053c683a879b0fd07a19814f057f3b7086d98a077f6946070021aaaea4250ef6d9f042b57a3eae9cc83de','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1098636&exception_mode=recommend&page=1','디시인사이드','2019-12-15 17:36:20','ko_KR'),(16,'OKKY | 아마존의 출격...양자 컴퓨터 전쟁에 핵폭탄 터졌다','  https://1boon.daum.net/techplus/5df1d8e034431474e93a382e           아마존이 양자 컴퓨터  판 에 뛰어들면서 기존 플레이어들의 셈법이 복잡해졌다. 양자 컴퓨터 성능 고도화를 우선했던 기존 전략을 전면 수정해야 할지도 모르기 때문이다. 연구개발(R D) 중심이었던 판을  서비스  시장으로 전환해버린 아마','//okky.kr/assets/okky_logo_fb-cea175ff727ef14a4d8be0e68cff730a.png','https://okky.kr/article/661117','OKKY','2019-12-15 18:48:21',''),(17,'메르시에 관한 프로들 명언모음.txt - 겐지 갤러리','\"어떻게 씨발 메르시같은 캐릭을 원챔으로 하지?  진짜 머리터질것 같은데..저런거하면.\"  \"메르시 씨발 좆같다. 이건 할말이없다.\" \"아 진짜 메르시원챔 왜함? 메르시 쓸','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1050c6831007309f867cb6cbfeb85d3f41dec12bccc72b4877a5ec4f1a1141d8cb00c6075c6b2169fc5cb0800e857fac','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1100163&exception_mode=recommend&page=1','디시인사이드','2019-12-16 14:20:00','ko_KR'),(18,'OKKY | 한국토스은행 생긴다',' http://m.zdnet.co.kr/news_view.asp?article_id 20191216110903 re zdk#imadnews           금융위, 인터넷전문은행 예비인가... 혁신 의지 뚜렷   금융위원회는 16일 오전 10시 임시 회의를 개최해  한국토스은행(가칭)  한 곳에 대해 인터넷전문은행 예비인가를 했다고 밝혔다.  은행의 예비','//okky.kr/assets/okky_logo_fb-cea175ff727ef14a4d8be0e68cff730a.png','https://okky.kr/article/661381','OKKY','2019-12-16 14:11:11',''),(19,'미라지 송하나 짤 sns에서 이상하게 퍼지네 ㅋㅋ.JPG - 겐지 갤러리','여자됨  - dc official App','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1050c6831007309f867cb6cbfdb05d3c4ad1c626f9b342fedfcc788a6509356a5671d1b12b66df916452ec24c1b61450d7289c9b803b97048c5cae8961bc9d1edcd1594205f0e591f9','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1100458&exception_mode=recommend&page=1','디시인사이드','2019-12-16 17:08:31','ko_KR'),(20,'겐지 마이너 갤러리는 정식 갤러리 승격을 거부합니다 - 겐지 갤러리','국내 최대 커뮤니티 포털 디시인사이드. 힛갤러리, 유저이슈 등 인터넷 트렌드 총 집합','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded87fa11d02831b24d3c2d27291c406c42f02d1a533e563100e791a31a7bd5bf870cd0b1a80c2a207503e859039ff46efb02b61d519f080a','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=765427&exception_mode=recommend&page=1','디시인사이드','2019-08-16 05:20:44','ko_KR'),(21,'OKKY | 새로운 웹 언어 WebAssembly','  https://www.w3.org/2019/12/pressrelease-wasm-rec.html.en   WebAssembly가 새로운 웹표준 언어로 발표되었다는 것 같네요 ','//okky.kr/assets/okky_logo_fb-cea175ff727ef14a4d8be0e68cff730a.png','https://okky.kr/article/661798','OKKY','2019-12-17 13:07:52',''),(22,'네? 누가 윙르시님을 사칭해서 계정을 판다구요? - 겐지 갤러리','와 근데 ㅋㅋㅋㅋㅋ 누구냐 ㅋㅋㅋㅋㅋ 밑에 태클거는 사람한테 한말인데 \"메원챔이랑듀오\"했겠어요?ㅋㅋㅋ 와 씨발 이건 계정 판것보다 더한거 아니냐? ','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd1051c683eb27d8f4c0823fa4fa01ddeb80ca4302d8154697daf8d1be157f175cf6d185181c3136a8bfe83b4de2541fd8ec2de1f819','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1102416&exception_mode=recommend&page=1','디시인사이드','2019-12-17 16:49:18','ko_KR'),(23,'위1 실드충 없는 사실 지어내는거봐라ㅋㅋ - 겐지 갤러리','야갤 집단폭행이란다10년가까이 야갤하루종일 쳐해도 한번도 못본일에다 검색해도 안나오는데존나 당당하게 ~한적 있다던데? 이지랄하긴 지어낸 에임 보면서 보짓물적시는것들이 말지어내는건 왜못하겠노 ㅋㅋ','https://write.dcinside.com/viewimage.php?id=owgenji&no=24b0d769e1d32ca73ded85fa11d028314c091b806630224048cd6cbd105ec683d0fb8e03e79588a26c5e2a10f3a67291152a71a31d6c8dbb473ef7e66d7ef521881d93815a780fc6dd84b1e435db8af9f95868301f548f18f3953148fd4b4779f7','https://gall.dcinside.com/mgallery/board/view/?id=owgenji&no=1103838&exception_mode=recommend&page=1','디시인사이드','2019-12-18 14:23:40','ko_KR'),(24,'OKKY | [펌] ‘배민’은 왜 상장하지 않았을까',' https://slownews.kr/74803          연말 스타트업 비즈니스와 딜 업계의 화두는 누가 뭐래도 우아한형제들(이하 ‘배민’)의 매각이다. 그러나 IPO(Initial public offering; 기업공개)가 아닌 M A(Merger   Acquisition; 인수합병) 방식의 매각을 선택한 것 때문에 업계에서는 의견이 다소 분분한 ','//okky.kr/assets/okky_logo_fb-cea175ff727ef14a4d8be0e68cff730a.png','https://okky.kr/article/662270','OKKY','2019-12-18 13:39:28','');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostUser`
--

DROP TABLE IF EXISTS `PostUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PostUser` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `postId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  PRIMARY KEY (`postId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `postuser_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `postuser_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PostUser`
--

LOCK TABLES `PostUser` WRITE;
/*!40000 ALTER TABLE `PostUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `PostUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SequelizeMeta`
--

DROP TABLE IF EXISTS `SequelizeMeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SequelizeMeta` (
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SequelizeMeta`
--

LOCK TABLES `SequelizeMeta` WRITE;
/*!40000 ALTER TABLE `SequelizeMeta` DISABLE KEYS */;
INSERT INTO `SequelizeMeta` VALUES ('20191206051513-netrigger.js');
/*!40000 ALTER TABLE `SequelizeMeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserCollection`
--

DROP TABLE IF EXISTS `UserCollection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserCollection` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` int(11) NOT NULL,
  `collectionId` int(11) NOT NULL,
  PRIMARY KEY (`userId`,`collectionId`),
  KEY `collectionId` (`collectionId`),
  CONSTRAINT `usercollection_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usercollection_ibfk_2` FOREIGN KEY (`collectionId`) REFERENCES `collections` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserCollection`
--

LOCK TABLES `UserCollection` WRITE;
/*!40000 ALTER TABLE `UserCollection` DISABLE KEYS */;
INSERT INTO `UserCollection` VALUES ('2019-12-11 19:12:12','2019-12-11 19:12:12',1,2);
/*!40000 ALTER TABLE `UserCollection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserCrwalset`
--

DROP TABLE IF EXISTS `UserCrwalset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserCrwalset` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` int(11) NOT NULL,
  `crawlsetId` int(11) NOT NULL,
  PRIMARY KEY (`userId`,`crawlsetId`),
  KEY `crawlsetId` (`crawlsetId`),
  CONSTRAINT `usercrwalset_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `usercrwalset_ibfk_2` FOREIGN KEY (`crawlsetId`) REFERENCES `crawlsets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserCrwalset`
--

LOCK TABLES `UserCrwalset` WRITE;
/*!40000 ALTER TABLE `UserCrwalset` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserCrwalset` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserKeyword`
--

DROP TABLE IF EXISTS `UserKeyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserKeyword` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` int(11) NOT NULL,
  `keywordId` int(11) NOT NULL,
  PRIMARY KEY (`userId`,`keywordId`),
  KEY `keywordId` (`keywordId`),
  CONSTRAINT `userkeyword_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userkeyword_ibfk_2` FOREIGN KEY (`keywordId`) REFERENCES `keywords` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserKeyword`
--

LOCK TABLES `UserKeyword` WRITE;
/*!40000 ALTER TABLE `UserKeyword` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserKeyword` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `nick` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `gender` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `birthday` datetime NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'jeewonre@gmail.com','jiwon','$2b$12$eFHP0z7DKL9U6CTZPsFEe.rFIMBNzSh9d.TfSvrxWMUid5r1HDEEq','male','1998-01-09 00:00:00','2019-12-11 14:18:44','2019-12-11 14:18:44',NULL);
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

-- Dump completed on 2019-12-19 17:40:20
