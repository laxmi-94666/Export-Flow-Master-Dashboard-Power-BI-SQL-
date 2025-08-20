-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: enquiry
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Current Database: `enquiry`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `enquiry` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `enquiry`;

--
-- Table structure for table `inquery`
--

DROP TABLE IF EXISTS `inquery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquery` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `TIMESTAMP` timestamp NULL DEFAULT NULL,
  `ORD_NUM` varchar(50) DEFAULT NULL,
  `BuyerId` int DEFAULT NULL,
  `Product` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3767 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_cancel`
--

DROP TABLE IF EXISTS `order_cancel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_cancel` (
  `TIMESTAMP` datetime DEFAULT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORD_NUM` varchar(50) DEFAULT NULL,
  `REASON` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `po_receive`
--

DROP TABLE IF EXISTS `po_receive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `po_receive` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Timestamp` datetime DEFAULT NULL,
  `ORD_NUM` varchar(50) DEFAULT NULL,
  `PO_RECEIVE_DATE` date DEFAULT NULL,
  `QUANTITY` int DEFAULT NULL,
  `PRICE_PER_PCS` double(10,2) DEFAULT NULL,
  `DELIVERY_DATE` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4307 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `order_details_responses_logistic`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `order_details_responses_logistic` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `order_details_responses_logistic`;

--
-- Table structure for table `buyer_currency`
--

DROP TABLE IF EXISTS `buyer_currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buyer_currency` (
  `ID` int NOT NULL,
  `BUYER_NAME` text,
  `BUYER_LOCATION` text,
  `BUYER_CURRENCY` text,
  `BUYER_PAYMENT_TERM_IN_DAYS` text,
  `MERCHANT` text,
  `exhange_rate` double(10,2) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `invoice_raised`
--

DROP TABLE IF EXISTS `invoice_raised`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_raised` (
  `TIMESTAMP` datetime DEFAULT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORD_NUM` varchar(50) DEFAULT NULL,
  `INVOICE_NO` text,
  `INVOICE_DATE` date DEFAULT NULL,
  `SHIP_QTY` int DEFAULT NULL,
  `SHIP_DATE` text,
  `TRANSPORT_TYPE` text,
  `CURRENT_CURRENCY_RATE` double DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3999 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `logistic_details`
--

DROP TABLE IF EXISTS `logistic_details`;
/*!50001 DROP VIEW IF EXISTS `logistic_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `logistic_details` AS SELECT 
 1 AS `ORD_NUM`,
 1 AS `BUYER`,
 1 AS `INVOICE_NO`,
 1 AS `ORDER_QTY`,
 1 AS `SHIP_QTY`,
 1 AS `PRICE`,
 1 AS `ORDER_VALUE`,
 1 AS `SHIP_VALUE`,
 1 AS `CURRENT_CURRENCY_RATE`,
 1 AS `ORDER_VALUE_INR`,
 1 AS `SHIP_VALUE_INR`,
 1 AS `PAYMENT_RECEIVED`,
 1 AS `PAYMENT_RECEIVED_INR`,
 1 AS `DELIVERY_DATE`,
 1 AS `SHIP_DATE`,
 1 AS `BUYER_PAYMENT_TERM_IN_DAYS`,
 1 AS `BUYER_LOCATION`,
 1 AS `BUYER_CURRENCY`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `payment_received`
--

DROP TABLE IF EXISTS `payment_received`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_received` (
  `ID` int NOT NULL,
  `TIMESTAMP` datetime DEFAULT NULL,
  `ORD_NUM` text,
  `RECEIVED_AMT` double DEFAULT NULL,
  `INVOICE_NUMBER` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `split_qty`
--

DROP TABLE IF EXISTS `split_qty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `split_qty` (
  `TIMESTAMP` datetime DEFAULT NULL,
  `ID` int NOT NULL AUTO_INCREMENT,
  `ORD_NUM` varchar(50) DEFAULT NULL,
  `SPLIT_ORDER` int DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=269 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transport_bill`
--

DROP TABLE IF EXISTS `transport_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transport_bill` (
  `TIMESTAMP` datetime DEFAULT NULL,
  `ID` int NOT NULL,
  `ORD_NUM` text,
  `AWB_BILL_NO` text,
  `INVOICE_NO` text,
  `SHIP_DATE` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `enquiry`
--

USE `enquiry`;

--
-- Current Database: `order_details_responses_logistic`
--

USE `order_details_responses_logistic`;

--
-- Final view structure for view `logistic_details`
--

/*!50001 DROP VIEW IF EXISTS `logistic_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `logistic_details` AS with `split_orders` as (select `po`.`ORD_NUM` AS `ORD_NUM`,(case when (`po`.`ORD_NUM` = `sq`.`ORD_NUM`) then (sum(`po`.`QUANTITY`) - `sq`.`SPLIT_ORDER`) else sum(`po`.`QUANTITY`) end) AS `QUANTITY`,max(`po`.`DELIVERY_DATE`) AS `DELIVERY_DATE`,`po`.`PRICE_PER_PCS` AS `PRICE`,`i`.`BuyerId` AS `BuyerId` from (((`enquiry`.`po_receive` `po` join (select `enquiry`.`inquery`.`ORD_NUM` AS `ORD_NUM`,`enquiry`.`inquery`.`BuyerId` AS `BuyerId` from `enquiry`.`inquery`) `i` on((`i`.`ORD_NUM` = `po`.`ORD_NUM`))) left join `split_qty` `sq` on((`sq`.`ORD_NUM` = `po`.`ORD_NUM`))) left join (select `enquiry`.`order_cancel`.`ORD_NUM` AS `ORD_NUM` from `enquiry`.`order_cancel`) `oc` on((`oc`.`ORD_NUM` = `po`.`ORD_NUM`))) where ((`oc`.`ORD_NUM` is null) and (`po`.`DELIVERY_DATE` >= '2023-04-01')) group by `po`.`ORD_NUM`,`sq`.`SPLIT_ORDER`,`po`.`PRICE_PER_PCS`,`i`.`BuyerId` union all select concat(`sq`.`ORD_NUM`,'-S(',count(`sq`.`ORD_NUM`) OVER (PARTITION BY `sq`.`ORD_NUM` ORDER BY `sq`.`ID` ) ,')') AS `ORD_NUM`,`sq`.`SPLIT_ORDER` AS `SPLIT_ORDER`,`po`.`DELIVERY_DATE` AS `DELIVERY_DATE`,`po`.`PRICE_PER_PCS` AS `PRICE`,`i`.`BuyerId` AS `BuyerId` from ((`split_qty` `sq` join (select `enquiry`.`inquery`.`ORD_NUM` AS `ORD_NUM`,`enquiry`.`inquery`.`BuyerId` AS `BuyerId` from `enquiry`.`inquery`) `i` on((`i`.`ORD_NUM` = `sq`.`ORD_NUM`))) join (select `enquiry`.`po_receive`.`ORD_NUM` AS `ORD_NUM`,`enquiry`.`po_receive`.`PRICE_PER_PCS` AS `PRICE_PER_PCS`,`enquiry`.`po_receive`.`DELIVERY_DATE` AS `DELIVERY_DATE` from `enquiry`.`po_receive`) `po` on((`po`.`ORD_NUM` = `sq`.`ORD_NUM`)))), `splitting` as (select `so`.`ORD_NUM` AS `ORD_NUM`,`inv`.`INVOICE_NO` AS `INVOICE_NO`,ifnull(round((`so`.`QUANTITY` / count(`inv`.`SHIP_DATE`) OVER (PARTITION BY `inv`.`ORD_NUM` ) ),2),`so`.`QUANTITY`) AS `ORDER_QTY`,`inv`.`SHIP_QTY` AS `SHIP_QTY`,`so`.`DELIVERY_DATE` AS `DELIVERY_DATE`,`inv`.`SHIP_DATE` AS `SHIP_DATE`,`inv`.`CURRENT_CURRENCY_RATE` AS `CURRENT_CURRENCY_RATE`,`so`.`PRICE` AS `PRICE`,`so`.`BuyerId` AS `BuyerId` from (`split_orders` `so` left join `invoice_raised` `inv` on((`inv`.`ORD_NUM` = `so`.`ORD_NUM`)))), `payment` as (select `payment_received`.`ORD_NUM` AS `ORD_NUM`,`payment_received`.`INVOICE_NUMBER` AS `INVOICE_NUMBER`,sum(`payment_received`.`RECEIVED_AMT`) AS `PAYMENT_RECEIVED` from `payment_received` group by `payment_received`.`ORD_NUM`,`payment_received`.`INVOICE_NUMBER`) select `s`.`ORD_NUM` AS `ORD_NUM`,`bc`.`BUYER_NAME` AS `BUYER`,`s`.`INVOICE_NO` AS `INVOICE_NO`,`s`.`ORDER_QTY` AS `ORDER_QTY`,`s`.`SHIP_QTY` AS `SHIP_QTY`,round(`s`.`PRICE`,2) AS `PRICE`,round((`s`.`ORDER_QTY` * `s`.`PRICE`),2) AS `ORDER_VALUE`,round((`s`.`SHIP_QTY` * `s`.`PRICE`),2) AS `SHIP_VALUE`,(case when (`s`.`SHIP_QTY` is null) then `bc`.`exhange_rate` else `s`.`CURRENT_CURRENCY_RATE` end) AS `CURRENT_CURRENCY_RATE`,round(((`s`.`ORDER_QTY` * `s`.`PRICE`) * (case when (`s`.`SHIP_QTY` is null) then `bc`.`exhange_rate` else `s`.`CURRENT_CURRENCY_RATE` end)),2) AS `ORDER_VALUE_INR`,round(((`s`.`SHIP_QTY` * `s`.`PRICE`) * `s`.`CURRENT_CURRENCY_RATE`),2) AS `SHIP_VALUE_INR`,`pr`.`PAYMENT_RECEIVED` AS `PAYMENT_RECEIVED`,round((`pr`.`PAYMENT_RECEIVED` * `s`.`CURRENT_CURRENCY_RATE`),2) AS `PAYMENT_RECEIVED_INR`,`s`.`DELIVERY_DATE` AS `DELIVERY_DATE`,`s`.`SHIP_DATE` AS `SHIP_DATE`,`bc`.`BUYER_PAYMENT_TERM_IN_DAYS` AS `BUYER_PAYMENT_TERM_IN_DAYS`,`bc`.`BUYER_LOCATION` AS `BUYER_LOCATION`,`bc`.`BUYER_CURRENCY` AS `BUYER_CURRENCY` from ((`splitting` `s` join `buyer_currency` `bc` on((`bc`.`ID` = `s`.`BuyerId`))) left join `payment` `pr` on(((`pr`.`ORD_NUM` = `s`.`ORD_NUM`) and (`pr`.`INVOICE_NUMBER` = `s`.`INVOICE_NO`)))) */;
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

-- Dump completed on 2025-08-21  0:05:37
