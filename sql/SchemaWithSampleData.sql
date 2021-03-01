drop database if exists c_center_db;
create database c_center_db;
use c_center_db;
-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: localhost    Database: c_center_db
-- ------------------------------------------------------
-- Server version	8.0.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `annual_sales`
--

DROP TABLE IF EXISTS `annual_sales`;
/*!50001 DROP VIEW IF EXISTS `annual_sales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `annual_sales` AS SELECT 
 1 AS `productId`,
 1 AS `productName`,
 1 AS `dateOfPurchase`,
 1 AS `productSale`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `attribute`
--

DROP TABLE IF EXISTS `attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attribute` (
  `attributeId` int NOT NULL AUTO_INCREMENT,
  `attributeName` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`attributeId`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attribute`
--

LOCK TABLES `attribute` WRITE;
/*!40000 ALTER TABLE `attribute` DISABLE KEYS */;
INSERT INTO `attribute` VALUES (1,'Color'),(2,'Size'),(4,'Price'),(5,'model'),(6,'camera'),(7,'dimension'),(8,'version type'),(12,'pages'),(15,'Material'),(16,'height'),(17,'Power'),(18,'Weight'),(19,'Hand Orientation'),(21,'Memory'),(22,'Processor');
/*!40000 ALTER TABLE `attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cartId` int NOT NULL AUTO_INCREMENT,
  `dateOfPurchase` date DEFAULT NULL,
  `state` varchar(15) NOT NULL,
  PRIMARY KEY (`cartId`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,'2021-03-01','close'),(2,'2021-02-02','close'),(3,'2021-02-01','close'),(4,'2021-03-01','close'),(5,'2020-08-02','close'),(6,'2020-03-01','open'),(7,'2020-11-20','open'),(8,NULL,'open'),(9,NULL,'open'),(13,NULL,'open'),(14,NULL,'open'),(19,NULL,'open'),(20,NULL,'open'),(21,NULL,'open'),(22,NULL,'open');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cartaddition`
--

DROP TABLE IF EXISTS `cartaddition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cartaddition` (
  `additionId` int NOT NULL AUTO_INCREMENT,
  `cartId` int DEFAULT NULL,
  `itemId` int DEFAULT NULL,
  `dateOfAddition` date DEFAULT NULL,
  PRIMARY KEY (`additionId`),
  KEY `cartId` (`cartId`),
  KEY `itemId` (`itemId`),
  CONSTRAINT `cartaddition_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `cart` (`cartId`),
  CONSTRAINT `cartaddition_ibfk_2` FOREIGN KEY (`itemId`) REFERENCES `item` (`itemId`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cartaddition`
--

LOCK TABLES `cartaddition` WRITE;
/*!40000 ALTER TABLE `cartaddition` DISABLE KEYS */;
INSERT INTO `cartaddition` VALUES (1,1,3,'2021-02-02'),(2,2,3,'2021-02-02'),(3,1,5,'2021-02-01'),(4,3,3,'2021-02-04'),(5,3,3,'2021-02-03'),(6,2,4,'2021-02-01'),(9,1,9,'2021-02-02'),(10,2,8,'2021-02-02'),(11,3,9,'2021-02-01'),(12,3,7,'2021-02-03'),(13,2,6,'2021-02-03'),(14,1,5,'2021-02-02'),(15,5,18,'2020-06-02'),(17,5,25,'2020-05-02'),(18,5,30,'2020-04-02'),(20,5,38,'2020-05-28'),(21,6,18,'2020-01-02'),(22,6,28,'2020-01-02'),(24,6,35,'2020-03-02'),(25,6,33,'2020-02-12'),(26,7,18,'2020-09-02'),(28,7,18,'2020-09-18'),(30,7,50,'2020-10-02'),(31,7,52,'2020-11-02'),(33,7,50,'2021-02-28'),(41,7,52,'2021-03-01'),(42,7,52,'2021-03-01'),(70,NULL,24,'2021-03-01'),(71,NULL,24,'2021-03-01'),(76,NULL,18,'2021-03-01'),(77,NULL,18,'2021-03-01'),(78,NULL,51,'2021-03-01'),(79,NULL,51,'2021-03-01'),(80,NULL,51,'2021-03-01'),(81,NULL,51,'2021-03-01'),(84,19,18,'2021-03-01'),(85,19,18,'2021-03-01'),(89,19,24,'2021-03-01'),(90,19,24,'2021-03-01'),(93,8,17,'2021-03-01'),(95,20,28,'2021-03-01'),(96,20,28,'2021-03-01'),(100,21,17,'2021-03-01'),(105,22,23,'2021-03-01'),(106,22,23,'2021-03-01'),(107,22,23,'2021-03-01'),(108,22,23,'2021-03-01'),(109,22,23,'2021-03-01');
/*!40000 ALTER TABLE `cartaddition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `categoryId` int NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`categoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'mobile phones'),(2,'Computers'),(3,'Stuffed toys'),(4,'Toy cars'),(5,'Action Figure'),(6,'TV'),(7,'DVD Players'),(8,'Calculators'),(9,'Camera'),(10,'Kitchen Electronics'),(11,'sport toys'),(12,'Building Toys'),(13,'puzzles'),(14,'Musical Instruments');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `email` varchar(30) NOT NULL,
  `firstName` varchar(30) DEFAULT NULL,
  `lastName` varchar(30) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `contactNumber` varchar(11) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `customerId` int NOT NULL AUTO_INCREMENT,
  `cityCode` int NOT NULL,
  PRIMARY KEY (`customerId`),
  KEY `cityCode` (`cityCode`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`cityCode`) REFERENCES `maincity` (`cityCode`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('customer1@gmail.com','charuka','rathnayaka','65/1 matara roaddfdf','2021-02-12','077-5727749','$2a$08$clE.Ks.uiVaEUci1q87dB.KuBxEl3YubuMVBW92ryC33s9Td8SZxC',3,200),('customer2@gmail.com','charuka2','rathnayaka2','65/1 mkghhgatara roaddfdf','2021-02-04','077-5547749','$2a$08$DK/peih1qSNc2ysUyARxZegA6A82CUf614pwvkQlcjL.I6vclNvoW',4,80000),('customer3@gmail.com','charuka3','rathnayaka3','45 colombo road','2021-02-04','077-5727709','$2a$10$j0snNK1tmyw7u62PmSsWF.jZgBk66Z.ct7sH5N.xiqc6A4PcIKSGq',5,81000),('e@gmail.com','pubudu','prabhathiya','29/5,gdd','2021-01-06','077-0899930','$2a$10$l1WrZzDpi/P8exhxrGMY2eraLcWTyALWb7EE6wz8ulQxP1xpnRcs2',6,80000),('csmr22897@gmail.com','Charitha','Rathnayake','pamburana, Matara','1997-08-22','071-1111111','$2a$10$bC7xHASA3DAaMXBLmD8VjO52njQBbydCdxB3ZMaCnovwGSrqD9ofu',7,81000);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `customer_orders`
--

DROP TABLE IF EXISTS `customer_orders`;
/*!50001 DROP VIEW IF EXISTS `customer_orders`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `customer_orders` AS SELECT 
 1 AS `email`,
 1 AS `firstName`,
 1 AS `lastName`,
 1 AS `cartId`,
 1 AS `productId`,
 1 AS `productName`,
 1 AS `itemId`,
 1 AS `dateOfPurchase`,
 1 AS `productSale`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `customercart`
--

DROP TABLE IF EXISTS `customercart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customercart` (
  `customerCartId` int NOT NULL AUTO_INCREMENT,
  `cartId` int DEFAULT NULL,
  `customerId` int NOT NULL,
  PRIMARY KEY (`customerCartId`),
  KEY `cartId` (`cartId`),
  KEY `customerId` (`customerId`),
  CONSTRAINT ` customercart_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `cart` (`cartId`),
  CONSTRAINT `customercart_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `customer` (`customerId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customercart`
--

LOCK TABLES `customercart` WRITE;
/*!40000 ALTER TABLE `customercart` DISABLE KEYS */;
INSERT INTO `customercart` VALUES (1,1,3),(2,2,4),(3,3,5),(4,4,3),(5,5,4),(6,6,5),(7,7,3),(8,19,7),(9,22,6);
/*!40000 ALTER TABLE `customercart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delieveryorder`
--

DROP TABLE IF EXISTS `delieveryorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delieveryorder` (
  `orderId` int NOT NULL,
  `delieveryAddress` varchar(50) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `contactNumber` varchar(11) DEFAULT NULL,
  `contactName` varchar(50) DEFAULT NULL,
  `delieveryEstimate` date DEFAULT NULL,
  PRIMARY KEY (`orderId`),
  CONSTRAINT `delieveryorder_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delieveryorder`
--

LOCK TABLES `delieveryorder` WRITE;
/*!40000 ALTER TABLE `delieveryorder` DISABLE KEYS */;
INSERT INTO `delieveryorder` VALUES (20,'65/1','Matara','077-5727749','charuka','2021-03-06'),(21,'65/1','Galle','077-5727749','charuka','2021-03-06'),(22,'65/1','Matara','077-5727749','charuka','2021-03-06'),(23,'29/5,gdd','Galle','077-0899930','pubudu','2021-03-06'),(24,'29/5,gdd','Matara','077-0899930','pubudu','2021-03-06'),(25,'29/5,gdd','Matara','077-0899930','pubudu','2021-03-09'),(26,'aa','Matara','012-3456789','a','2021-03-09');
/*!40000 ALTER TABLE `delieveryorder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `division`
--

DROP TABLE IF EXISTS `division`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `division` (
  `divisionId` int NOT NULL AUTO_INCREMENT,
  `divisionName` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`divisionId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `division`
--

LOCK TABLES `division` WRITE;
/*!40000 ALTER TABLE `division` DISABLE KEYS */;
INSERT INTO `division` VALUES (1,'Toy'),(2,'Electronic');
/*!40000 ALTER TABLE `division` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `divisioncategorydetail`
--

DROP TABLE IF EXISTS `divisioncategorydetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `divisioncategorydetail` (
  `divisionId` int NOT NULL,
  `categoryId` int NOT NULL,
  PRIMARY KEY (`divisionId`,`categoryId`),
  KEY `categoryId` (`categoryId`),
  CONSTRAINT `divisioncategorydetail_ibfk_2` FOREIGN KEY (`categoryId`) REFERENCES `category` (`categoryId`),
  CONSTRAINT `divisioncategorydetail_ibfk_3` FOREIGN KEY (`divisionId`) REFERENCES `division` (`divisionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `divisioncategorydetail`
--

LOCK TABLES `divisioncategorydetail` WRITE;
/*!40000 ALTER TABLE `divisioncategorydetail` DISABLE KEYS */;
INSERT INTO `divisioncategorydetail` VALUES (2,1),(2,2),(1,3),(1,4),(1,5),(2,6),(2,7),(2,8),(2,9),(2,10),(1,11),(1,12),(1,13),(1,14);
/*!40000 ALTER TABLE `divisioncategorydetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `email` varchar(30) NOT NULL,
  `firstName` varchar(30) DEFAULT NULL,
  `lastName` varchar(30) DEFAULT NULL,
  `employeeId` int DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  `dateOfRecruitment` date DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `telephoneNumber` int DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES ('admin@ccenter.com','adminfirst','adminlast',1,'admin','2021-02-02','2021-02-01',774567891,'$2a$08$0PD63yi1evUyCFS3ZNsY4uX3eeQKeqenRCNN0XMpAof9Io.rc4BPq'),('salesmanager1@ccenter.com','SalesManager1','last',17,'Sales manager','2021-02-02','2021-02-02',77,'$2a$08$YijJSqSGEJmF2urPQrM3guuvEMlfvHkG0xtKLyOBYCgItL.wVNctO'),('warehouseofficer1@ccenter.com','warehouseOfficer1','lastofficer',NULL,'Warehouse officer','2021-02-01','2021-02-04',77,'$2a$08$2PadkPNd7RllxZx7SFt/V.g8WDLR8aqR6BwGdKYo2qonmt1.yu2Tu');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guest`
--

DROP TABLE IF EXISTS `guest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guest` (
  `guestId` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`guestId`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guest`
--

LOCK TABLES `guest` WRITE;
/*!40000 ALTER TABLE `guest` DISABLE KEYS */;
INSERT INTO `guest` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26);
/*!40000 ALTER TABLE `guest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guest cart`
--

DROP TABLE IF EXISTS `guest cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guest cart` (
  `guestCartId` int NOT NULL AUTO_INCREMENT,
  `cartId` int DEFAULT NULL,
  `guestId` int DEFAULT NULL,
  PRIMARY KEY (`guestCartId`),
  KEY `cartId` (`cartId`),
  KEY `guestId` (`guestId`),
  CONSTRAINT `guest cart_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `cart` (`cartId`),
  CONSTRAINT `guest cart_ibfk_2` FOREIGN KEY (`guestId`) REFERENCES `guest` (`guestId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guest cart`
--

LOCK TABLES `guest cart` WRITE;
/*!40000 ALTER TABLE `guest cart` DISABLE KEYS */;
INSERT INTO `guest cart` VALUES (1,8,24),(2,9,19),(3,20,20),(4,21,25);
/*!40000 ALTER TABLE `guest cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `itemId` int NOT NULL AUTO_INCREMENT,
  `productId` int DEFAULT NULL,
  `itemCount` int DEFAULT NULL,
  PRIMARY KEY (`itemId`),
  KEY `productId` (`productId`),
  CONSTRAINT `item_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
INSERT INTO `item` VALUES (3,3,3),(4,4,3),(5,3,-1),(6,2,10),(7,5,13),(8,6,4),(9,7,1),(10,8,6),(11,8,3),(12,8,3),(13,9,3),(14,9,7),(15,10,5),(16,10,4),(17,11,5),(18,11,3),(19,12,6),(20,12,8),(21,13,4),(22,13,4),(23,14,4),(24,14,4),(25,15,5),(26,15,5),(27,16,5),(28,16,4),(29,17,4),(30,18,3),(31,18,3),(32,19,5),(33,19,4),(34,20,4),(35,20,4),(36,21,4),(37,21,6),(38,22,4),(39,22,4),(40,23,6),(41,24,3),(42,24,8),(43,25,7),(44,25,11),(45,26,4),(46,26,10),(47,27,4),(48,28,4),(49,29,19),(50,30,3),(51,30,7),(52,31,5),(53,31,6),(54,32,4),(55,32,6),(56,33,5),(57,33,4),(58,34,7),(59,35,4),(60,36,11),(61,36,17),(62,37,11),(63,37,5),(64,38,4),(65,39,10),(66,40,23),(67,41,4),(68,42,12),(69,43,10);
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itemdetail`
--

DROP TABLE IF EXISTS `itemdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itemdetail` (
  `itemId` int NOT NULL,
  `attributeId` int NOT NULL,
  `value` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`itemId`,`attributeId`),
  KEY `attributeId` (`attributeId`),
  CONSTRAINT `itemdetail_ibfk_1` FOREIGN KEY (`itemId`) REFERENCES `item` (`itemId`),
  CONSTRAINT `itemdetail_ibfk_2` FOREIGN KEY (`attributeId`) REFERENCES `attribute` (`attributeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemdetail`
--

LOCK TABLES `itemdetail` WRITE;
/*!40000 ALTER TABLE `itemdetail` DISABLE KEYS */;
INSERT INTO `itemdetail` VALUES (3,1,'red'),(3,2,'small'),(3,4,'7500'),(3,5,'2021'),(3,6,'32mp'),(4,1,'red'),(4,4,'1800'),(4,7,'100*55'),(5,1,'Gold'),(5,4,'85000'),(5,5,'2021'),(5,8,'Pro'),(6,1,'white'),(6,2,'small'),(6,4,'1000'),(7,1,'red'),(7,4,'900'),(7,5,'45.5'),(8,4,'2000'),(8,8,'1.0'),(9,2,'large'),(9,4,'4500'),(9,12,'10'),(10,1,'red'),(10,4,'1200'),(10,5,'2021'),(11,1,'yellow'),(11,4,'1000'),(12,1,'black'),(12,2,'small'),(12,4,'1000'),(13,1,'Black'),(13,2,'Medium'),(13,4,'1100'),(13,15,'Plastic'),(14,1,'Gold'),(14,2,'Medium'),(14,4,'1500'),(14,15,'Plastic'),(15,1,'Red'),(15,4,'1000'),(15,15,'Metal'),(16,1,'Gold'),(16,4,'1450'),(16,15,'Polygram'),(17,1,'brown'),(17,4,'2000'),(17,15,'Plastic'),(17,16,'7 inches'),(18,1,'Gold'),(18,4,'2500'),(18,15,'Metal'),(18,16,'8 inches'),(19,1,'Black'),(19,4,'800'),(19,15,'plastic'),(19,16,'7 inches'),(20,1,'Gold'),(20,4,'1100'),(20,15,'Polygram'),(20,16,'5 inches'),(21,1,'red'),(21,4,'2500'),(21,16,'6 inches'),(21,17,'Battery'),(22,1,'red'),(22,2,'9 inches'),(22,4,'3100'),(22,17,'battery'),(23,1,'Black'),(23,4,'32000'),(23,7,'1920*1080'),(23,8,'2020'),(24,1,'Grey'),(24,4,'35000'),(24,5,'2021 pro'),(24,7,'1900*2000'),(25,1,'black'),(25,4,'40000'),(25,5,'2020'),(25,7,'2000*2100'),(26,1,'black'),(26,4,'45000'),(26,5,'2021 pro'),(26,7,'2000*2150'),(27,1,'brown'),(27,4,'41000'),(27,5,'2021 ECO'),(27,7,'1800*1650'),(28,1,'black'),(28,4,'46800'),(28,5,'2021 ECO Max'),(29,1,'black'),(29,4,'53000'),(29,5,'2021 ECO-M'),(29,7,'2000*2100'),(30,1,'brown'),(30,4,'35500'),(30,5,'2019 HIGH'),(31,1,'black'),(31,4,'32000'),(31,5,'2018 LOW'),(32,1,'black'),(32,4,'55000'),(32,5,'2020 LG IQ'),(32,7,'2400*2500'),(33,1,'brown'),(33,4,'60000'),(33,5,'2021 ULTRA'),(33,7,'2500*2600'),(34,1,'black'),(34,4,'24000'),(34,5,'2018 DVD'),(34,17,'AC'),(35,1,'Grey'),(35,4,'25000'),(35,5,'2020 PRO'),(36,1,'black'),(36,4,'30000'),(36,5,'2021 ULTRA'),(37,1,'brown'),(37,4,'28000'),(37,5,'2020 Clean'),(38,1,'black'),(38,4,'2000'),(38,17,'Battery'),(39,1,'white'),(39,4,'3500'),(39,5,'2020'),(39,17,'Solar Power'),(40,1,'black'),(40,4,'60000'),(40,6,'32MP'),(40,18,'500g'),(41,1,'black'),(41,4,'70000'),(41,6,'64MP'),(41,18,'600g'),(42,1,'Grey'),(42,4,'84000'),(42,5,'2021 ULTRA'),(42,6,'64MP'),(42,18,'450g'),(43,1,'black'),(43,4,'80000'),(43,5,'2020 LONG'),(43,6,'32MP'),(44,1,'Grey'),(44,4,'90000'),(44,5,'2021 CLEAR'),(44,6,'64MP'),(44,18,'800g'),(45,1,'white'),(45,4,'40000'),(45,5,'2018 Clean'),(45,18,'3.5 Kg'),(46,1,'white'),(46,4,'45000'),(46,5,'2021 Ultra ECO'),(46,18,'3.2 Kg'),(47,1,'white'),(47,4,'3000'),(47,18,'900g'),(48,1,'Red & White'),(48,4,'5100'),(48,18,'5 Kg'),(49,4,'1200'),(49,15,'Plastic'),(49,18,'500g'),(50,1,'red'),(50,4,'800'),(50,5,'Jigzaw 1.1'),(51,1,'Gold'),(51,2,'large'),(51,4,'950'),(52,2,'large'),(52,4,'1450'),(52,15,'Plastic'),(53,2,'Small'),(53,4,'1100'),(53,15,'Plastic'),(54,1,'white'),(54,4,'7100'),(54,17,'Electric'),(54,18,'1.7 Kg'),(55,1,'black'),(55,4,'11000'),(55,17,'Battery'),(55,18,'2 Kg'),(56,1,'white'),(56,2,'medium'),(56,4,'3800'),(57,1,'red'),(57,2,'large'),(57,4,'4200'),(58,1,'brown'),(58,4,'7100'),(58,15,'Wood'),(58,18,'800g'),(59,1,'black'),(59,4,'12100'),(59,15,'Wood'),(59,18,'6kg'),(60,1,'Black'),(60,2,'Small'),(60,4,'150000'),(60,5,'2020'),(60,6,'64mp'),(61,1,'Blue'),(61,2,'Small'),(61,4,'150000'),(61,5,'2020'),(61,6,'64mp'),(62,1,'Black'),(62,4,'120000'),(62,8,'TaylorMade'),(62,19,'Right'),(63,1,'Black'),(63,4,'120000'),(63,8,'TaylorMade'),(63,19,'Left'),(64,1,'Black'),(64,2,'15.6\" FHD 1920x1080'),(64,4,'435000'),(64,21,'16GB DDR4 3200Mhz'),(64,22,'Intel® Core™ i7-10870H 16M Cache'),(65,1,'Grey'),(65,4,'6000'),(65,5,'Plastic'),(65,15,'Stainless Steel'),(65,17,'NBR-0601'),(66,1,'Brown'),(66,4,'1500'),(66,16,'10\"'),(67,1,'Plush'),(67,4,'5000'),(68,1,'Metallica Grey'),(68,2,'7 x 7 x 14 inches'),(68,4,'5000'),(68,15,'Plastic'),(68,18,'3.5 kg'),(69,1,'Just Black'),(69,2,'6\"'),(69,4,'149990'),(69,8,'2021'),(69,21,'8 GB');
/*!40000 ALTER TABLE `itemdetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maincity`
--

DROP TABLE IF EXISTS `maincity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maincity` (
  `cityCode` int NOT NULL AUTO_INCREMENT,
  `cityName` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`cityCode`)
) ENGINE=InnoDB AUTO_INCREMENT=81001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maincity`
--

LOCK TABLES `maincity` WRITE;
/*!40000 ALTER TABLE `maincity` DISABLE KEYS */;
INSERT INTO `maincity` VALUES (200,'Colombo'),(10400,'Kaluthara'),(11000,'Gampaha'),(20000,'Kandy'),(50000,'Anuradhapura'),(70000,'Rathnapura'),(80000,'Galle'),(81000,'Matara');
/*!40000 ALTER TABLE `maincity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `most_prefer_period`
--

DROP TABLE IF EXISTS `most_prefer_period`;
/*!50001 DROP VIEW IF EXISTS `most_prefer_period`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `most_prefer_period` AS SELECT 
 1 AS `productId`,
 1 AS `productName`,
 1 AS `productSale`,
 1 AS `saleQuantity`,
 1 AS `monthYear`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `orderId` int NOT NULL AUTO_INCREMENT,
  `cartId` int DEFAULT NULL,
  `delieveryMethod` varchar(30) DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`orderId`),
  KEY `Fk` (`cartId`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `cart` (`cartId`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (2,2,'Delievery','close'),(3,3,'Pickup','open'),(4,4,'Delievery','open'),(5,5,'Pickup','open'),(6,6,'Delievery','open'),(7,7,'Delievery','open'),(20,1,'delieveryorder','open'),(21,1,'delieveryorder','open'),(22,1,'delieveryorder','open'),(23,1,'delieveryorder','open'),(24,1,'delieveryorder','open'),(25,1,'delieveryorder','open'),(26,4,'delieveryorder','open');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `orderId` int NOT NULL,
  `paymentMethod` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`orderId`),
  KEY `FK,PK` (`orderId`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (20,'65/1'),(21,'65/1'),(22,'65/1'),(23,'29/5,gdd'),(24,'29/5,gdd'),(25,'29/5,gdd'),(26,'aa');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pickuporder`
--

DROP TABLE IF EXISTS `pickuporder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pickuporder` (
  `orderId` int NOT NULL,
  `pickupDate` date DEFAULT NULL,
  `contactNumber` varchar(11) DEFAULT NULL,
  `contactName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`orderId`),
  CONSTRAINT `pickuporder_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pickuporder`
--

LOCK TABLES `pickuporder` WRITE;
/*!40000 ALTER TABLE `pickuporder` DISABLE KEYS */;
/*!40000 ALTER TABLE `pickuporder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `productId` int NOT NULL AUTO_INCREMENT,
  `productName` varchar(30) DEFAULT NULL,
  `description` text,
  `photoLink` text NOT NULL,
  PRIMARY KEY (`productId`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (2,'Orca Stuffed animal','Our snuggly soft Orca Kids Toys are among the most popular items in the WDC Kids Toys collection. Orca Plush stuffed animals serve as a gentle reminder for children and adults that taking care of whal','product_image-1612608943190.jpg'),(3,'Apple IPhone X','Apple today announced iPhone X, the future of the smartphone, in a gorgeous all-glass design with a beautiful 5.8-inch Super Retina display, A11 Bionic chip, wireless charging and an improved rear cam','product_image-1612609802726.jpg'),(4,'Racing Diecast Car','Bburago 1:24 Ferrari Race & Play LaFerrari Racing Diecast Car Toys/Play Red 3y+','product_image-1612610788096.jpg'),(5,'Remote Control Racing car','Planet of Toys bring the most functional remote control racing sports car 1:12 scale with the amazing feature of opening the door with remote control. Other prominent functions include forward, revers','product_image-1612611042027.jpg'),(6,'Ramon Teddy Bear','Ramon tan teddy with realistic paw pad accents and heart shaped tummy Sideways smile adds cute personality Surface-washable construction Appropriate for ages one and up 18 inch height (45.72 cm)','product_image-1612611133050.jpg'),(7,'IMac 5k 2021','Apple offers an excellent lineup of three 27-inch iMac versions, starting with the entry-level model that includes a 3.1GHz 6-Core 10th-generation Intel Core i5 processor with Turbo Boost up to 4.5GHz','product_image-1612611216503.jpg'),(8,'Marvel Avengers Action Figures','Includes 8 Action Figures of Captain America, Iron Man, Black Panther, Spider-Man, Daredevil, War Machine, the Incredible Hulk, and Falcon 6\" Tall Action Figures','product_image-1614437431526.jpg'),(9,'Marvel Legends','Marvel Legends Series 3 3/4-Inch Action Figures Case brings you 8 individually packaged 3 3/4-inch scale plastic heroes and villains, ready to do battle with an infinite number of heroes and villains.','product_image-1614437523139.jpg'),(10,'Iron Man Toy','6-Inch scale collectible iron Man figure: fans, collectors, and kids alike can enjoy this 6-inch-scale iron Man figure, inspired by the character from the Marvel Comics','product_image-1614437687511.jpg'),(11,'Justice League 7 ','Contains Justice League icons Superman, Batman, Wonder Woman, Green Lantern, The Flash, Aquaman and Cyborg Figures are 7\" high','product_image-1614438148946.jpg'),(12,'Batman Figure','6-inch scale with deluxe costume. 20+ points of articulation for authenti­­­­­­c battle action and posing.','product_image-1614438338948.jpg'),(13,'Flash Chain Lightnening','Recreates The Flash from Chain Lightning Figure stands 6\" tall Multiple accessories Exceptional detail','product_image-1614438415631.jpg'),(14,'Samsung LCD 32\' Tv',' Brand	SAMSUNG Resolution	1920x1080 Connectivity Technology	Wireless Screen Size: 32\" Backlight Technology: LED Aspect Ratio: 16:9','product_image-1614480057473.jpg'),(15,'Samsung LCD 60\" Tv',' Appliances Online Samsung UA60KU6000 60 Inch 152cm Smart Ultra HD LCD Aspect Ratio: 16:9  Samsung\'s 470 Series Hospitality TVs feature direct-lit','product_image-1614480248257.jpg'),(16,'Samsung LED 32\' Tv','Screen Size	32 Inches Resolution	1366 x 768 Pixels Brand	Samsung Speaker Type	4 Channel Number of HDMI Ports	2 Number of USB Ports	1','product_image-1614480349008.jpeg'),(17,'SONY LED 43\' Tv','Sony Bravia 108 cm (43 inches) Full HD Smart LED TV 43W6600 (Black) (2020 Model) Smart TV Features: Smart TV | Screen Mirroring | Netflix | Amazon Prime Video | HDR Gaming','product_image-1614480452399.jpg'),(18,'Sony LCD 40\" Tv','Brand	Sony Bravia Connectivity	2 x HDM, 2 x USB Screen Size	40 Inch Screen Type	LCD Resolution	1920 x 1080 Full HD Speaker Output	8 W x 2','product_image-1614480603993.jpg'),(19,'LG 50\" TV','LG 50 inch Class 4K Smart UHD TV w/AI ThinQ® (49.5\'\' Diag)  4K LCD Display LG ThinQ AI | Google Assistant | Alexa Quad Core Processor4K Active HDR','product_image-1614480723872.jpg'),(20,'Samsung DVD player 2012','2012 DVD Player ( DVD-E360/ZA )   Design ConceptTray Deck. LED Display, Tact Switch Controls   Dolby DigitalYes DTS OutputYes','product_image-1614480834184.jpg'),(21,'Sony DVD player','Super dustproof High picture quality with Xvid Home Wide playability USB Play DVD-Video/CD/Video CD/SVCD: Yes/Yes/Yes/Yes MP3 (CD-R/RW): Yes/Yes Xvid (CD-R/RW): Yes/Yes','product_image-1614480916730.jpg'),(22,'Scientific Calculator ','(FX-991ES) Color: white Power Source	Solar, Battery Brand	Casio Color	White Item Dimensions LxWxH	0.98 x 1.3 x 0.59 inches','product_image-1614481046161.jpg'),(23,'Nikon D3400 DSLR Camera','24.2MP DX-Format CMOS Sensor EXPEED 4 Image Processor No Optical Low-Pass Filter SnapBridge Bluetooth Connectivity','product_image-1614481143703.jpg'),(24,'Sony DSLR Alpha','the Alpha 6600 can capture 4K video at 30fps. The camera includes both a microphone as well as a headphone jack. Multiple picture profiles are provided, including S-Log3 and S-Log2','product_image-1614481283812.jpg'),(25,'Canon EOS 4000D DSLR Camera','Canon EOS 4000D DSLR Camera Body (International Version/ No US Warranty )- 18.0MP APS-C CMOS Sensor,DIGIC 4+ Image Processor','product_image-1614481394627.jpg'),(26,'Microwave','23 L Solo Tact (Buttons) : Even with hands soiled with dough, these buttons can be used','product_image-1614481515453.jpeg'),(27,'Kookaburra Junior Cricket Bat','Kashmir Willow Standard Handle style Standard toe profile Players Grip style Sizes: 1,2,3,4,5,6,H','product_image-1614481674105.jpg'),(28,'Football Door Toy Set','Deerbb Football Door Toy Set 60cm for Boys 3 4 5 6 Years Old, Kids Gift Age 7 8 9 10 Yr Sport Soccer Ball Goals with Net ','product_image-1614481747934.jpg'),(29,'LEGO build Box','LEGO Classic Large Creative Brick Box 10698  Kids Building Kit (790 Pieces)','product_image-1614481966254.jpg'),(30,'Mapology - Jigsaw Puzzle','It consists of 3 Foam puzzle frame of 6mm each, 65 country shape Pieces Smaller countries pieces have been clubbed to make the handling of puzzle easier for a child','product_image-1614482058712.jpg'),(31,'Jigsaw Puzzle -1000','A Falcon de luxe 1000 piece jigsaw puzzle A picturesque scene of a local beach on a beautiful summer\'s day Illustrated by Debbie Cook Produced using a high quality cardboard','product_image-1614482185314.jpg'),(32,' Organ 25 Keys Keyboard','5 Keys multi-functional electronic keyboard piano for kids This electronic keyboard is the chinese version, please buy it if you don\'t mind Powered by 3 x AA batteries','product_image-1614482271226.jpg'),(33,'Percussion Instruments Set','Toddler Musical Instruments Ehome 15 Types 22pcs Wooden Percussion Instruments Toy for Kids Preschool Educational, Musical Toys Set','product_image-1614482353854.jpg'),(34,'Violin 4 strings','PRODUCT DETAILS- Materials- Plastic and Metal. Dimensions: 18” L x 6.5” W. Requires 2 AA Batteries (Not Included). Includes Violin and Bow.','product_image-1614482424723.jpg'),(35,' Piano 37 Keys','LYBALL Kids Piano 37 Keys Multi-Function Keyboard Piano Kids Toy Piano with Microphone & MP3 Music Function Kids Starter Music Keyboard Silver 16.92 inches','product_image-1614482535420.jpg'),(36,'Samsung Galaxy S20','Meet Galaxy S20. With revolutionary 8K Video Snap, 5G connectivity and Space Zoom up to 100x, the way you capture and share your life will never be the same.','product_image-1614604969399.jpg'),(37,'Kalea Complete Golf Set','TaylorMade Golf Kalea Complete Golf Set (Dr, 3FW, 5FW, 5H, 6H, 7-PW, SW, Putter, Bag)','product_image-1614606912507.jpg'),(38,'MSI GP66 LEOPARD RTX 3060','Dedicated thermal solutions for both the CPU and GPU with up to 6 heat pipes, work harmoniously by minimizing the heat and maximizing the airflow for smooth gaming performance in a compact chassis.','product_image-1614607381994.png'),(39,'NutriBullet NBR-0601','The NutriBullet is the fastest, easiest solution for making nutrient- packed smoothies.','product_image-1614608803263.jpg'),(40,'GUND Puddles Dog','Puddles the dog with ultra-soft plush that’s perfect for cuddling','product_image-1614609391480.jpg'),(41,'Plush Dog House','Plush Dog House -Five (5) Stuffed Animal Dogs (Dalmation, Yellow Lab, Rottweiler, Poodle, Cocker Spaniel) in Play Dog House Carrying House','product_image-1614609493468.jpg'),(42,'Oster Pro 1200','Oster Pro 1200 Blender with Professional Tritan Jar and Food Processor attachment, Metallic Grey','product_image-1614609732827.jpg'),(43,'Google Pixel 5','Google Pixel 5 - 5G Android Phone - Water Resistant - Unlocked Smartphone with Night Sight and Ultrawide Lens - Just Black','product_image-1614609908065.jpg');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productcategorydetail`
--

DROP TABLE IF EXISTS `productcategorydetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productcategorydetail` (
  `productId` int NOT NULL,
  `categoryId` int NOT NULL,
  PRIMARY KEY (`productId`,`categoryId`),
  KEY `categoryId` (`categoryId`),
  CONSTRAINT `productcategorydetail_ibfk_1` FOREIGN KEY (`categoryId`) REFERENCES `category` (`categoryId`),
  CONSTRAINT `productcategorydetail_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productcategorydetail`
--

LOCK TABLES `productcategorydetail` WRITE;
/*!40000 ALTER TABLE `productcategorydetail` DISABLE KEYS */;
INSERT INTO `productcategorydetail` VALUES (3,1),(36,1),(43,1),(7,2),(38,2),(2,3),(6,3),(40,3),(41,3),(4,4),(5,4),(8,5),(9,5),(10,5),(11,5),(12,5),(13,5),(14,6),(15,6),(16,6),(17,6),(18,6),(19,6),(20,7),(21,7),(22,8),(23,9),(24,9),(25,9),(26,10),(39,10),(42,10),(27,11),(28,11),(37,11),(29,12),(30,13),(31,13),(32,14),(33,14),(34,14),(35,14);
/*!40000 ALTER TABLE `productcategorydetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productdivisiondetail`
--

DROP TABLE IF EXISTS `productdivisiondetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productdivisiondetail` (
  `productId` int NOT NULL,
  `divisionId` int NOT NULL,
  PRIMARY KEY (`productId`,`divisionId`),
  KEY `divisionId` (`divisionId`),
  CONSTRAINT `productdivisiondetail_ibfk_1` FOREIGN KEY (`divisionId`) REFERENCES `division` (`divisionId`),
  CONSTRAINT `productdivisiondetail_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productdivisiondetail`
--

LOCK TABLES `productdivisiondetail` WRITE;
/*!40000 ALTER TABLE `productdivisiondetail` DISABLE KEYS */;
INSERT INTO `productdivisiondetail` VALUES (2,1),(4,1),(5,1),(6,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(27,1),(28,1),(29,1),(30,1),(31,1),(32,1),(33,1),(34,1),(35,1),(36,1),(37,1),(38,1),(39,1),(40,1),(41,1),(42,1),(43,1),(3,2),(7,2),(14,2),(15,2),(16,2),(17,2),(18,2),(19,2),(20,2),(21,2),(22,2),(23,2),(24,2),(25,2),(26,2);
/*!40000 ALTER TABLE `productdivisiondetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productsubcategorydetail`
--

DROP TABLE IF EXISTS `productsubcategorydetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productsubcategorydetail` (
  `productId` int NOT NULL,
  `subCategoryId` int NOT NULL,
  PRIMARY KEY (`productId`,`subCategoryId`),
  KEY `subCategoryId` (`subCategoryId`),
  CONSTRAINT `productsubcategorydetail_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`),
  CONSTRAINT `productsubcategorydetail_ibfk_2` FOREIGN KEY (`subCategoryId`) REFERENCES `subcategory` (`subCategoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productsubcategorydetail`
--

LOCK TABLES `productsubcategorydetail` WRITE;
/*!40000 ALTER TABLE `productsubcategorydetail` DISABLE KEYS */;
INSERT INTO `productsubcategorydetail` VALUES (36,2),(43,2),(3,3),(7,4),(38,5),(2,6),(6,6),(40,7),(41,7),(5,8),(4,9),(5,9),(8,10),(9,10),(10,10),(11,11),(12,11),(13,11),(17,12),(18,12),(21,12),(24,12),(14,13),(15,13),(16,13),(20,13),(19,14),(14,15),(15,15),(18,15),(16,16),(17,16),(19,16),(22,17),(23,18),(25,19),(27,20),(37,21),(28,22),(29,23),(30,24),(31,25),(30,26),(31,26),(32,27),(35,27),(32,28),(35,28),(33,29),(34,30),(26,31),(39,32),(42,32);
/*!40000 ALTER TABLE `productsubcategorydetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subcategory`
--

DROP TABLE IF EXISTS `subcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subcategory` (
  `subCategoryId` int NOT NULL AUTO_INCREMENT,
  `subCategoryName` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`subCategoryId`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subcategory`
--

LOCK TABLES `subcategory` WRITE;
/*!40000 ALTER TABLE `subcategory` DISABLE KEYS */;
INSERT INTO `subcategory` VALUES (1,NULL),(2,'Android'),(3,'IOS'),(4,'Desktop computers'),(5,'Laptop Computer'),(6,'Teddy Bears'),(7,'stuffed dogs'),(8,'Remote Control Cars'),(9,'Racing cars'),(10,'Marvel'),(11,'DC'),(12,'Sony'),(13,'Samsung'),(14,'LG'),(15,'LCD'),(16,'LED'),(17,'Casio'),(18,'Nikon'),(19,'Canon'),(20,'Cricket Bat'),(21,'Golf Set'),(22,'Football set'),(23,'LEGO'),(24,'Map Puzzle'),(25,'Image Puzzle'),(26,'Jigzaw puzzle'),(27,'Organ'),(28,'Piano'),(29,'Percussion'),(30,'Violin'),(31,'Microwaves'),(32,'Blenders');
/*!40000 ALTER TABLE `subcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subcategorydetail`
--

DROP TABLE IF EXISTS `subcategorydetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subcategorydetail` (
  `categoryId` int NOT NULL,
  `subCategoryId` int NOT NULL,
  PRIMARY KEY (`categoryId`,`subCategoryId`),
  KEY `subCategoryId` (`subCategoryId`),
  CONSTRAINT `subcategorydetail_ibfk_1` FOREIGN KEY (`categoryId`) REFERENCES `category` (`categoryId`),
  CONSTRAINT `subcategorydetail_ibfk_2` FOREIGN KEY (`subCategoryId`) REFERENCES `subcategory` (`subCategoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subcategorydetail`
--

LOCK TABLES `subcategorydetail` WRITE;
/*!40000 ALTER TABLE `subcategorydetail` DISABLE KEYS */;
INSERT INTO `subcategorydetail` VALUES (1,2),(1,3),(2,4),(2,5),(3,6),(3,7),(4,8),(4,9),(5,10),(5,11),(6,12),(7,12),(9,12),(6,13),(7,13),(6,14),(7,14),(6,15),(6,16),(8,17),(9,18),(9,19),(11,20),(11,21),(11,22),(12,23),(13,24),(13,25),(13,26),(14,27),(14,28),(14,29),(14,30),(10,31),(10,32);
/*!40000 ALTER TABLE `subcategorydetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `top_categories`
--

DROP TABLE IF EXISTS `top_categories`;
/*!50001 DROP VIEW IF EXISTS `top_categories`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `top_categories` AS SELECT 
 1 AS `categoryId`,
 1 AS `categoryName`,
 1 AS `productQuantity`,
 1 AS `productSale`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'c_center_db'
--

--
-- Dumping routines for database 'c_center_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_new_item` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_new_item`(
    
    Product_ID int(15),
	ItemCount int(10),
    num_common_attributes int,
    common_attributes varchar(3000),
    common_attribute_values varchar(3000),
    num_custom_attributes int,
    custom_attribute_names varchar(3000),
    custom_attribute_values varchar(3000)
    )
BEGIN
    DECLARE i INT(8) DEFAULT 0;
    DECLARE j INT(8) DEFAULT 0;
    DECLARE item_id INT DEFAULT 0;
    START TRANSACTION;
        INSERT INTO `item`(`productId`,`itemCount`) VALUES (Product_ID,ItemCount);
        SET item_id = LAST_INSERT_ID();
        
        
        REPEAT SET i = i + 1;
        INSERT INTO  `itemdetail`(itemId,attributeId,value) VALUES (item_id,TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(common_attributes, ',', i), ',', -1)),TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(common_attribute_values, ',', i), ',', -1)));
        UNTIL i >= num_common_attributes
        END REPEAT;

        IF LENGTH(custom_attribute_names)>0 THEN
        REPEAT SET j = j + 1;
        INSERT INTO  `attribute`(attributeName) VALUES (TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(custom_attribute_names, ',', j), ',', -1)));
        INSERT INTO  `itemdetail`(itemId,attributeId,value) VALUES (item_id, LAST_INSERT_ID(),TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(custom_attribute_values, ',', j), ',', -1)));
        UNTIL j >= num_custom_attributes
        END REPEAT;
        END IF;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_new_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_new_product`(
    
    Product_name varchar(30),
	Description varchar(200),
    Photo_Link varchar(255),
    Division_ID int(15),
    num_categories int,
    categories varchar(3000),
    num_sub_categories int,
    sub_categories varchar(3000)
    )
BEGIN
    DECLARE i INT(8) DEFAULT 0;
    DECLARE j INT(8) DEFAULT 0;
    START TRANSACTION;
        INSERT INTO `product`(`productName`,`description`,`photoLink`) VALUES (Product_name,Description,Photo_Link);
        INSERT INTO `productdivisiondetail`(`productId`,`divisionId`) VALUES (LAST_INSERT_ID(),"1");
        REPEAT SET i = i + 1;
        INSERT INTO  `productcategorydetail`(productId,categoryId) VALUES (LAST_INSERT_ID(),TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(categories, ',', i), ',', -1)));
        UNTIL i >= num_categories
        END REPEAT;

        REPEAT SET j = j + 1;
        INSERT INTO  `productsubcategorydetail`(productId,subCategoryId) VALUES (LAST_INSERT_ID(),TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(sub_categories, ',', j), ',', -1)));
        UNTIL j >= num_sub_categories
        END REPEAT;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `add_to_cart` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_to_cart`(
    
    cartId INT(10),
    itemId INT(15),
    quantity INT)
BEGIN
    DECLARE i INT(8) DEFAULT 0;
    START TRANSACTION;
        
        REPEAT SET i = i + 1;
        INSERT INTO `cartaddition`( `cartId`, `itemId`, `dateOfAddition`) VALUES (cartId,itemId,(SELECT CURRENT_DATE()));
        UNTIL i >= quantity
        END REPEAT;
        
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_cart_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_cart_customer`(
    
    Id INT(10))
BEGIN
    START TRANSACTION;
        
        INSERT INTO `cart`(`state`) VALUES ("open");
        SELECT @cartId:=MAX(cartId) FROM `cart`;
        INSERT INTO `customercart`(`cartId`, `customerId`) VALUES (@cartId,Id);

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_cart_guest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_cart_guest`(
    
    Id VARCHAR(30))
BEGIN
    START TRANSACTION;
        
        INSERT INTO `cart`(`state`) VALUES ("open");
        SELECT @cartId:=MAX(cartId) FROM `cart`;
        INSERT INTO `guest cart` (`cartId`, `guestId`) VALUES (@cartId,Id);
        
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delievery_Order_Iteam` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delievery_Order_Iteam`(
    userType varchar(11),
    customerId int(10),
  state varchar(30) ,
     delieveryAddress varchar(50)	 ,
  city	varchar(20)	 ,
  contactNumber	varchar(11)	,
  contactName	varchar(50)	,
  paymentMethod varchar(20)
    )
BEGIN
    DECLARE order_id INT DEFAULT 0;
    DECLARE numofItem INT DEFAULT 0;
     DECLARE i INT(8) DEFAULT 0;
     DECLARE idcart INT(10) DEFAULT 4;
    DECLARE ItemQuantity INT(5) DEFAULT 0;
     DECLARE isMainCity INT(5) DEFAULT 0;
     DECLARE delieveryEstimate date ;
    START TRANSACTION;
    IF (userType = "gust") THEN
    select `cartId` INTO idcart from `guest cart`left outer join cart using(cartId) where `guestId`=customerId and `state`='open' limit 1;
   ELSEIF (userType ="customer") THEN
       select `cartId` INTO idcart from  customercart left outer join cart using(cartId) where `customerId`=customerId and `state`='open' limit 1;
	end if;
     
        INSERT INTO `order`(`cartId`, `delieveryMethod`, `state`) VALUES (idcart,'delieveryorder',state);
        SET order_id = LAST_INSERT_ID();
        
INSERT INTO `payment`(`orderId`, `paymentMethod`) VALUES (order_id,paymentMethod);
UPDATE `cart` SET `dateOfPurchase`=curdate(),`state`='close'  WHERE `cartId`=idcart;
UPDATE item s
JOIN (
   select itemId as itemId , COUNT(itemId) as itemC from cartAddition where cartId=idcart group by itemId
) vals ON s.itemId = vals.itemId
SET itemCount =itemCount- itemC;
 select min(itemCount) into ItemQuantity from cart inner join cartAddition using(cartId) inner join item using(itemId);
 select count(cityName) into isMainCity from maincity where cityName=city;
IF (isMainCity>0) THEN
	IF (0<ItemQuantity) THEN
    set delieveryEstimate=ADDDATE(curdate(), 5);
    else
    set delieveryEstimate=ADDDATE(curdate(), 8);
	END IF;
ELSEIF (isMainCity<0) THEN
	IF (0<ItemQuantity) THEN
    set delieveryEstimate=ADDDATE(curdate(), 7);
    else
    set delieveryEstimate=ADDDATE(curdate(), 10);
	END IF;
END IF;    
INSERT INTO `delieveryorder`(`orderId`, `delieveryAddress`, `city`, `contactNumber`, `contactName`, `delieveryEstimate`) VALUES (order_id,delieveryAddress,city,contactNumber,contactName,delieveryEstimate);
COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pickup_Order_Iteam` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `pickup_Order_Iteam`(
    userType varchar(11),
    customerId int(10),
  state varchar(30) ,
     pickupDate date ,
  contactNumber varchar(11) ,
  contactName varchar(50),
  paymentMethod varchar(20)
    )
BEGIN
DECLARE idcart INT(10) DEFAULT 0;
    DECLARE order_id INT DEFAULT 0;
    START TRANSACTION;
   IF (userType = "gust") THEN
    select `cart.cartId` INTO idcart from `guest cart` left outer join cart as cart using(cartId) where `guestId`=customerId and `state`='open' limit 1;
   ELSEIF (userType ="customer") THEN
       select `cart.cartId` INTO idcart from  customercart left outer join cart as cart using(cartId) where `customerId`=customerId and `state`='open' limit 1;
	end if;
   
        INSERT INTO `order`(`cartId`, `delieveryMethod`, `state`) VALUES (idcart,'pickuporder',state);
        SET order_id = LAST_INSERT_ID();
        INSERT INTO `pickuporder`(`orderId`, `pickupDate`, `contactNumber`, `contactName`) VALUES (order_id,pickupDate,contactNumber,contactName);
INSERT INTO `payment`(`orderId`, `paymentMethod`) VALUES (order_id,paymentMethod);
UPDATE `cart` SET `dateOfPurchase`=curdate(),`state`='close' WHERE `cartId`=CartId;
UPDATE item s
JOIN (
   select itemId as itemId , COUNT(itemId) as itemC from cartAddition where cartId=idcart group by itemId
) vals ON s.itemId = vals.itemId
SET itemCount =itemCount- itemC;
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Update_cart_iteam` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_cart_iteam`(
    
    Item_ID int(15),
	cartId int(10),
    Value int(100))
BEGIN
    
    DECLARE ItemQuantity INT(5) DEFAULT 0;
     DECLARE i INT(8) DEFAULT 0;
    START TRANSACTION;
        
        
        select count(itemId) INTO ItemQuantity from cartAddition where itemId=Item_ID and cartId=cartId limit 1;
        SET ItemQuantity=ItemQuantity-Value;
        IF (0>ItemQuantity) THEN
        
            REPEAT SET i = i + 1;
            insert into cartAddition(cartId,itemId,dateOfAddition) values(cartId,Item_ID,curdate());
            UNTIL i >= -ItemQuantity
        END REPEAT;
        ELSE
        IF (0<ItemQuantity) THEN
            delete from cartAddition where itemId=Item_ID and cartId=cartId order by dateOfAddition desc limit ItemQuantity;
                END IF;
        
       END IF;
        
      
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_item_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_item_count`(
    
    Item_ID int(15),
	NewItemQuantity int(5))
BEGIN
    
    DECLARE ItemQuantity INT(5) DEFAULT 0;
    
    START TRANSACTION;
        
        
        SELECT itemCount INTO ItemQuantity FROM `item` where itemId=Item_ID LIMIT 1;
        SET ItemQuantity = ItemQuantity + NewItemQuantity;
        UPDATE `item` SET itemCount=ItemQuantity WHERE itemId=Item_ID;
      
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `annual_sales`
--

/*!50001 DROP VIEW IF EXISTS `annual_sales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `annual_sales` AS select `product`.`productId` AS `productId`,`product`.`productName` AS `productName`,`cart`.`dateOfPurchase` AS `dateOfPurchase`,`itemdetail`.`value` AS `productSale` from ((((`cartaddition` left join (`order` join `cart` on(((`order`.`cartId` = `cart`.`cartId`) and (`order`.`state` = `cart`.`state`)))) on((`cart`.`cartId` = `cartaddition`.`cartId`))) left join `item` on((`cartaddition`.`itemId` = `item`.`itemId`))) join `product` on((`item`.`productId` = `product`.`productId`))) left join `itemdetail` on((`item`.`itemId` = `itemdetail`.`itemId`))) where (`itemdetail`.`attributeId` = 4) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `customer_orders`
--

/*!50001 DROP VIEW IF EXISTS `customer_orders`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `customer_orders` AS select `customer`.`email` AS `email`,`customer`.`firstName` AS `firstName`,`customer`.`lastName` AS `lastName`,`cart`.`cartId` AS `cartId`,`product`.`productId` AS `productId`,`product`.`productName` AS `productName`,`item`.`itemId` AS `itemId`,`cart`.`dateOfPurchase` AS `dateOfPurchase`,`itemdetail`.`value` AS `productSale` from ((((((`cartaddition` left join (`order` join `cart` on(((`order`.`cartId` = `cart`.`cartId`) and (`order`.`state` = `cart`.`state`)))) on((`cart`.`cartId` = `cartaddition`.`cartId`))) left join `customercart` on((`cart`.`cartId` = `customercart`.`cartId`))) left join `customer` on((`customercart`.`customerId` = `customer`.`customerId`))) left join `item` on((`cartaddition`.`itemId` = `item`.`itemId`))) join `product` on((`item`.`productId` = `product`.`productId`))) left join `itemdetail` on((`item`.`itemId` = `itemdetail`.`itemId`))) where (`itemdetail`.`attributeId` = 4) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `most_prefer_period`
--

/*!50001 DROP VIEW IF EXISTS `most_prefer_period`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `most_prefer_period` AS select `product`.`productId` AS `productId`,`product`.`productName` AS `productName`,sum(`itemdetail`.`value`) AS `productSale`,count(`item`.`itemId`) AS `saleQuantity`,date_format(`cartaddition`.`dateOfAddition`,'%m-%Y') AS `monthYear` from ((((`cartaddition` left join (`order` join `cart` on(((`order`.`cartId` = `cart`.`cartId`) and (`order`.`state` = `cart`.`state`)))) on((`cart`.`cartId` = `cartaddition`.`cartId`))) left join `item` on((`cartaddition`.`itemId` = `item`.`itemId`))) join `product` on((`item`.`productId` = `product`.`productId`))) left join `itemdetail` on((`item`.`itemId` = `itemdetail`.`itemId`))) where (`itemdetail`.`attributeId` = 4) group by `product`.`productId`,month(`cartaddition`.`dateOfAddition`),year(`cartaddition`.`dateOfAddition`) order by `saleQuantity` desc limit 5 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `top_categories`
--

/*!50001 DROP VIEW IF EXISTS `top_categories`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `top_categories` AS select `category`.`categoryId` AS `categoryId`,`category`.`categoryName` AS `categoryName`,count(`item`.`itemId`) AS `productQuantity`,sum(`itemdetail`.`value`) AS `productSale` from (((`productcategorydetail` left join (((`cartaddition` left join (`order` join `cart` on(((`order`.`cartId` = `cart`.`cartId`) and (`order`.`state` = `cart`.`state`)))) on((`cart`.`cartId` = `cartaddition`.`cartId`))) left join `item` on((`cartaddition`.`itemId` = `item`.`itemId`))) join `product` on((`item`.`productId` = `product`.`productId`))) on((`product`.`productId` = `productcategorydetail`.`productId`))) join `category` on((`productcategorydetail`.`categoryId` = `category`.`categoryId`))) left join `itemdetail` on((`item`.`itemId` = `itemdetail`.`itemId`))) where (`itemdetail`.`attributeId` = 4) group by `category`.`categoryId` order by `productQuantity` desc limit 10 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-01 21:42:17
