-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.45 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.15.0.7171
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for techmart
CREATE DATABASE IF NOT EXISTS `techmart` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `techmart`;

-- Dumping structure for table techmart.cart_items
CREATE TABLE IF NOT EXISTS `cart_items` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CUSTOMERID` int DEFAULT NULL,
  `PRODUCTID` int DEFAULT NULL,
  `QUANTITY` int DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table techmart.cart_items: ~0 rows (approximately)
INSERT INTO `cart_items` (`ID`, `CUSTOMERID`, `PRODUCTID`, `QUANTITY`) VALUES
	(8, 1, 7, 2);

-- Dumping structure for table techmart.notifications
CREATE TABLE IF NOT EXISTS `notifications` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CREATEDTIME` datetime DEFAULT NULL,
  `ISREAD` tinyint(1) DEFAULT '0',
  `MESSAGE` longtext,
  `USERID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table techmart.notifications: ~3 rows (approximately)
INSERT INTO `notifications` (`ID`, `CREATEDTIME`, `ISREAD`, `MESSAGE`, `USERID`) VALUES
	(1, '2026-07-02 20:37:01', 0, 'Product Update: \'test3\' details have been updated. New Price: $40000', '1'),
	(2, '2026-07-03 10:25:30', 0, 'New Purchase! Customer: Sithika Samadith (sisirakumarasisirakumara123@gmail.com) purchased 1 item(s) - Total: $6000', '3'),
	(3, '2026-07-03 10:25:30', 0, 'New Purchase! Customer: Sithika Samadith (sisirakumarasisirakumara123@gmail.com) purchased 1 item(s) - Total: $6000', '2'),
	(4, '2026-07-03 10:25:33', 0, 'Order confirmation ORD-ORD-1783054528343 has been processed.', '1'),
	(5, '2026-07-03 11:23:34', 0, 'New Arrival: \'test5\' is now available in our store for $500!', '1'),
	(6, '2026-07-03 13:00:10', 0, 'New Arrival: \'test6\' is now available in our store for $300!', '1');

-- Dumping structure for table techmart.orders
CREATE TABLE IF NOT EXISTS `orders` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `CUSTOMEREMAIL` varchar(255) DEFAULT NULL,
  `CUSTOMERID` int DEFAULT NULL,
  `CUSTOMERNAME` varchar(255) DEFAULT NULL,
  `ORDERDATE` datetime DEFAULT NULL,
  `ORDERITEMS` longtext,
  `ORDERSTATUS` varchar(255) DEFAULT NULL,
  `TOTALAMOUNT` decimal(38,0) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table techmart.orders: ~5 rows (approximately)
INSERT INTO `orders` (`ID`, `CUSTOMEREMAIL`, `CUSTOMERID`, `CUSTOMERNAME`, `ORDERDATE`, `ORDERITEMS`, `ORDERSTATUS`, `TOTALAMOUNT`) VALUES
	(1, 'sisirakumarasisirakumara123@gmail.com', 1, 'Sithika Samadith', '2026-07-03 10:25:28', '{5=2}', 'PENDING', 6000),
	(2, 'sisirakumarasisirakumara123@gmail.com', 1, 'Sithika Samadith', '2026-07-03 10:54:51', '{5=1}', 'PENDING_PAYMENT', 3000),
	(3, 'sisirakumarasisirakumara123@gmail.com', 1, 'Sithika Samadith', '2026-07-03 10:55:06', '{5=1}', 'PENDING_PAYMENT', 3000),
	(4, 'sisirakumarasisirakumara123@gmail.com', 1, 'Sithika Samadith', '2026-07-03 11:12:27', '{5=1}', 'CONFIRMED', 3000),
	(5, 'sisirakumarasisirakumara123@gmail.com', 1, 'Sithika Samadith', '2026-07-03 11:20:05', '{5=1}', 'CONFIRMED', 3000),
	(6, 'sisirakumarasisirakumara123@gmail.com', 1, 'Sithika Samadith', '2026-07-03 13:02:25', '{6=1, 7=1}', 'CONFIRMED', 800),
	(7, 'sisirakumarasisirakumara123@gmail.com', 1, 'Sithika Samadith', '2026-07-04 11:15:29', '{7=1}', 'CONFIRMED', 300);

-- Dumping structure for table techmart.payments
CREATE TABLE IF NOT EXISTS `payments` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `AMOUNT` decimal(38,0) NOT NULL,
  `CARDBRAND` varchar(255) DEFAULT NULL,
  `CARDLASTFOUR` varchar(255) DEFAULT NULL,
  `CREATEDAT` datetime DEFAULT NULL,
  `CURRENCY` varchar(255) NOT NULL,
  `CUSTOMERID` int DEFAULT NULL,
  `METADATA` longtext,
  `ORDERID` int DEFAULT NULL,
  `PAYMENTDATE` datetime DEFAULT NULL,
  `STATUS` varchar(255) NOT NULL,
  `STRIPEPAYMENTINTENTID` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table techmart.payments: ~2 rows (approximately)
INSERT INTO `payments` (`ID`, `AMOUNT`, `CARDBRAND`, `CARDLASTFOUR`, `CREATEDAT`, `CURRENCY`, `CUSTOMERID`, `METADATA`, `ORDERID`, `PAYMENTDATE`, `STATUS`, `STRIPEPAYMENTINTENTID`) VALUES
	(1, 3000, 'stripe', 'Xf7a', '2026-07-03 11:12:30', 'USD', 1, NULL, 4, '2026-07-03 11:12:30', 'succeeded', 'pi_3Tozrr2LY9N7Z9cs13B7Xf7a'),
	(2, 3000, 'stripe', 'hIPS', '2026-07-03 11:20:07', 'USD', 1, NULL, 5, '2026-07-03 11:20:07', 'succeeded', 'pi_3TozzF2LY9N7Z9cs0o4bhIPS'),
	(3, 800, 'stripe', 'DvDf', '2026-07-03 13:02:27', 'USD', 1, NULL, 6, '2026-07-03 13:02:27', 'succeeded', 'pi_3Tp1aH2LY9N7Z9cs01vdDvDf'),
	(4, 300, 'stripe', 'GCiZ', '2026-07-04 11:15:31', 'USD', 1, NULL, 7, '2026-07-04 11:15:31', 'succeeded', 'pi_3TpMOM2LY9N7Z9cs1xlbGCiZ');

-- Dumping structure for table techmart.products
CREATE TABLE IF NOT EXISTS `products` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `PRICE` decimal(38,0) DEFAULT NULL,
  `STOCKQUANTITY` int DEFAULT NULL,
  `IMAGEPATH` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table techmart.products: ~2 rows (approximately)
INSERT INTO `products` (`ID`, `DESCRIPTION`, `NAME`, `PRICE`, `STOCKQUANTITY`, `IMAGEPATH`) VALUES
	(4, 'THis is 3rd test', 'test3', 40000, 6, 'uploads/WhatsApp Image 2026-03-07 at 19.10.51.jpeg'),
	(5, 'This is testing5', 'test4', 3000, 17, 'uploads/WhatsApp Image 2026-03-07 at 19.10.50.jpeg'),
	(6, 'this is testing 5 product', 'test5', 500, 5, 'uploads/WhatsApp Image 2026-03-07 at 19.10.50.jpeg'),
	(7, 'this is testing 6', 'test6', 300, 4, 'uploads/WhatsApp Image 2026-03-07 at 19.10.51.jpeg');

-- Dumping structure for table techmart.users
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `EMAIL` varchar(255) DEFAULT NULL,
  `FIRSTNAME` varchar(255) DEFAULT NULL,
  `LASTNAME` varchar(255) DEFAULT NULL,
  `PASSWORD` varchar(255) DEFAULT NULL,
  `USERTYPE` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table techmart.users: ~0 rows (approximately)
INSERT INTO `users` (`ID`, `EMAIL`, `FIRSTNAME`, `LASTNAME`, `PASSWORD`, `USERTYPE`) VALUES
	(1, 'sisirakumarasisirakumara123@gmail.com', 'Sithika', 'Samadith', 'Sithika123@', 'CUSTOMER'),
	(2, 'saman@gmail.com', 'saman', 'kumara', 'Saman@#', 'ADMIN'),
	(3, 'admin@techmart.com', 'System', 'Admin', 'admin123', 'ADMIN');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
