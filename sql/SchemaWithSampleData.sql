
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `c_center_db`
--

drop database if exists c_center_db;
create database c_center_db;
use c_center_db; 

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_new_item` (`Product_ID` INT(15), `ItemCount` INT(10), `num_common_attributes` INT, `common_attributes` VARCHAR(3000), `common_attribute_values` VARCHAR(3000), `num_custom_attributes` INT, `custom_attribute_names` VARCHAR(3000), `custom_attribute_values` VARCHAR(3000))  BEGIN
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

        REPEAT SET j = j + 1;
        INSERT INTO  `attribute`(attributeName) VALUES (TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(custom_attribute_names, ',', j), ',', -1)));
        INSERT INTO  `itemdetail`(itemId,attributeId,value) VALUES (item_id, LAST_INSERT_ID(),TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(custom_attribute_values, ',', j), ',', -1)));
        UNTIL j >= num_custom_attributes
        END REPEAT;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_new_product` (`Product_name` VARCHAR(30), `Description` VARCHAR(200), `Photo_Link` VARCHAR(255), `Division_ID` INT(15), `num_categories` INT, `categories` VARCHAR(3000), `num_sub_categories` INT, `sub_categories` VARCHAR(3000))  BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_item_count` (`Item_ID` INT(15), `NewItemQuantity` INT(5))  BEGIN
    
    DECLARE ItemQuantity INT(5) DEFAULT 0;
    
    START TRANSACTION;
        
        
        SELECT itemCount INTO ItemQuantity FROM `item` where itemId=Item_ID LIMIT 1;
        SET ItemQuantity = ItemQuantity + NewItemQuantity;
        UPDATE `item` SET itemCount=ItemQuantity WHERE itemId=Item_ID;
      
    COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `attribute`
--

CREATE TABLE `attribute` (
  `attributeId` int(5) NOT NULL,
  `attributeName` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `attribute`
--

INSERT INTO `attribute` (`attributeId`, `attributeName`) VALUES
(1, 'Color'),
(2, 'Size'),
(4, 'Price'),
(5, 'model'),
(6, 'camera'),
(7, 'dimension'),
(8, 'version type'),
(12, 'pages');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cartId` int(10) NOT NULL,
  `dateOfPurchase` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`cartId`, `dateOfPurchase`) VALUES
(1, '2021-02-04'),
(2, '2021-02-02'),
(3, '2021-02-01'),
(4, '2021-02-02');

-- --------------------------------------------------------

--
-- Table structure for table `cartaddition`
--

CREATE TABLE `cartaddition` (
  `additionId` int(10) NOT NULL,
  `cartId` int(10) DEFAULT NULL,
  `itemId` int(15) DEFAULT NULL,
  `dateOfAddition` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `cartaddition`
--

INSERT INTO `cartaddition` (`additionId`, `cartId`, `itemId`, `dateOfAddition`) VALUES
(1, 1, 3, '2021-02-02'),
(2, 2, 3, '2021-02-02'),
(3, 1, 5, '2021-02-01'),
(4, 3, 3, '2021-02-04'),
(5, 3, 3, '2021-02-03'),
(6, 2, 4, '2021-02-01'),
(7, 4, 5, '2021-02-03'),
(8, 1, 5, '2021-02-02'),
(9, 1, 9, '2021-02-02'),
(10, 2, 8, '2021-02-02'),
(11, 3, 9, '2021-02-01'),
(12, 3, 7, '2021-02-03'),
(13, 2, 6, '2021-02-03'),
(14, 1, 5, '2021-02-02');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `categoryId` int(10) NOT NULL,
  `categoryName` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`categoryId`, `categoryName`) VALUES
(1, 'mobile phones'),
(2, 'Computers'),
(3, 'Stuffed toys'),
(4, 'Toy cars');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `email` varchar(30) NOT NULL,
  `firstName` varchar(30) DEFAULT NULL,
  `lastName` varchar(30) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `contactNumber` varchar(11) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`email`, `firstName`, `lastName`, `address`, `city`, `dateOfBirth`, `contactNumber`, `password`) VALUES
('customer1@gmail.com', 'charuka', 'Rathnayaka', '65/1 matara road', 'Matara', '1997-09-12', '077-5547449', '$2a$08$9UXkX82/wP0LTBUV48j8M.xja5qslJ0XbO2g/IImwigtRAO8/9bM2'),
('customer2@gmail.com', 'customer2', 'ascsc', '45 colombo road', 'this.cityCode', '2021-02-01', '077-5727709', '$2a$08$LEeZAfFcQQv/GT8m1nFt5.pzk0Wg2.qHpA/zOlUsdtv7kZs8YIqWa');

-- --------------------------------------------------------

--
-- Table structure for table ` customercart`
--

CREATE TABLE ` customercart` (
  `customerCartId` int(10) NOT NULL,
  `cartId` int(10) DEFAULT NULL,
  `email` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `delieveryorder`
--

CREATE TABLE `delieveryorder` (
  `orderId` int(10) NOT NULL,
  `delieveryAddress` varchar(50) DEFAULT NULL,
  `city` varchar(20) DEFAULT NULL,
  `contactNumber` varchar(11) DEFAULT NULL,
  `        contactName` varchar(50) DEFAULT NULL,
  `delieveryEstimate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `division`
--

CREATE TABLE `division` (
  `divisionId` int(10) NOT NULL,
  `divisionName` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `division`
--

INSERT INTO `division` (`divisionId`, `divisionName`) VALUES
(1, 'Toy'),
(2, 'Electronic');

-- --------------------------------------------------------

--
-- Table structure for table `divisioncategorydetail`
--

CREATE TABLE `divisioncategorydetail` (
  `divisionId` int(10) NOT NULL,
  `categoryId` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `divisioncategorydetail`
--

INSERT INTO `divisioncategorydetail` (`divisionId`, `categoryId`) VALUES
(1, 3),
(1, 4),
(2, 1),
(2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `email` varchar(30) NOT NULL,
  `firstName` varchar(30) DEFAULT NULL,
  `lastName` varchar(30) DEFAULT NULL,
  `employeeId` int(5) DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  `dateOfRecruitment` date DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `telephoneNumber` int(10) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`email`, `firstName`, `lastName`, `employeeId`, `role`, `dateOfRecruitment`, `dateOfBirth`, `telephoneNumber`, `password`) VALUES
('admin@ccenter.com', 'adminfirst', 'adminlast', 1, 'admin', '2021-02-02', '2021-02-01', 774567891, '$2a$08$0PD63yi1evUyCFS3ZNsY4uX3eeQKeqenRCNN0XMpAof9Io.rc4BPq'),
('salesmanager1@ccenter.com', 'SalesManager1', 'last', 17, 'Sales manager', '2021-02-02', '2021-02-02', 77, '$2a$08$YijJSqSGEJmF2urPQrM3guuvEMlfvHkG0xtKLyOBYCgItL.wVNctO'),
('warehouseofficer1@ccenter.com', 'warehouseOfficer1', 'lastofficer', NULL, 'Warehouse officer', '2021-02-01', '2021-02-04', 77, '$2a$08$2PadkPNd7RllxZx7SFt/V.g8WDLR8aqR6BwGdKYo2qonmt1.yu2Tu');

-- --------------------------------------------------------

--
-- Table structure for table `guest`
--

CREATE TABLE `guest` (
  `guestId` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `guest`
--

INSERT INTO `guest` (`guestId`) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17);

-- --------------------------------------------------------

--
-- Table structure for table `guest cart`
--

CREATE TABLE `guest cart` (
  `guestCartId` int(10) NOT NULL,
  `cartId` int(10) DEFAULT NULL,
  `guestId` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `itemId` int(15) NOT NULL,
  `productId` int(15) DEFAULT NULL,
  `itemCount` int(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `item`
--

INSERT INTO `item` (`itemId`, `productId`, `itemCount`) VALUES
(3, 3, 9),
(4, 4, 3),
(5, 3, 3),
(6, 2, 4),
(7, 5, 13),
(8, 6, 4),
(9, 7, 7);

-- --------------------------------------------------------

--
-- Table structure for table `itemdetail`
--

CREATE TABLE `itemdetail` (
  `itemId` int(15) NOT NULL,
  `attributeId` int(5) NOT NULL,
  `value` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `itemdetail`
--

INSERT INTO `itemdetail` (`itemId`, `attributeId`, `value`) VALUES
(3, 1, 'red'),
(3, 2, 'small'),
(3, 4, '7500'),
(3, 5, '2021'),
(3, 6, '32mp'),
(4, 1, 'red'),
(4, 4, '1800'),
(4, 7, '100*55'),
(5, 1, 'Gold'),
(5, 4, '85000'),
(5, 5, '2021'),
(5, 8, 'Pro'),
(6, 1, 'white'),
(6, 2, 'small'),
(6, 4, '1000'),
(7, 1, 'red'),
(7, 4, '900'),
(7, 5, '45.5'),
(8, 4, '2000'),
(8, 8, '1.0'),
(9, 2, 'large'),
(9, 4, '4500'),
(9, 12, '10');

-- --------------------------------------------------------

--
-- Table structure for table `maincity`
--

CREATE TABLE `maincity` (
  `cityCode` int(5) NOT NULL,
  `cityName` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `maincity`
--

INSERT INTO `maincity` (`cityCode`, `cityName`) VALUES
(200, 'Colombo'),
(10400, 'Kaluthara'),
(11000, 'Gampaha'),
(20000, 'Kandy'),
(50000, 'Anuradhapura'),
(70000, 'Rathnapura'),
(80000, 'Galle'),
(81000, 'Matara');

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `orderId` int(10) NOT NULL,
  `cartId` int(10) DEFAULT NULL,
  `delieveryMethod` varchar(30) DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `orderId` int(10) NOT NULL,
  `paymentMethod` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `pickuporder`
--

CREATE TABLE `pickuporder` (
  `orderId` int(10) NOT NULL,
  `pickupDate` date DEFAULT NULL,
  `contactNumber` varchar(11) DEFAULT NULL,
  `contactName` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `productId` int(15) NOT NULL,
  `productName` varchar(30) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `photoLink` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`productId`, `productName`, `description`, `photoLink`) VALUES
(2, 'Orca Stuffed animal', 'Our snuggly soft Orca Kids Toys are among the most popular items in the WDC Kids Toys collection. Orca Plush stuffed animals serve as a gentle reminder for children and adults that taking care of whal', 'product_image-1612608943190.jpg'),
(3, 'Apple IPhone X', 'Apple today announced iPhone X, the future of the smartphone, in a gorgeous all-glass design with a beautiful 5.8-inch Super Retina display, A11 Bionic chip, wireless charging and an improved rear cam', 'product_image-1612609802726.jpg'),
(4, 'Racing Diecast Car', 'Bburago 1:24 Ferrari Race & Play LaFerrari Racing Diecast Car Toys/Play Red 3y+', 'product_image-1612610788096.jpg'),
(5, 'Remote Control Racing car', 'Planet of Toys bring the most functional remote control racing sports car 1:12 scale with the amazing feature of opening the door with remote control. Other prominent functions include forward, revers', 'product_image-1612611042027.jpg'),
(6, 'Ramon Teddy Bear', 'Ramon tan teddy with realistic paw pad accents and heart shaped tummy Sideways smile adds cute personality Surface-washable construction Appropriate for ages one and up 18 inch height (45.72 cm)', 'product_image-1612611133050.jpg'),
(7, 'IMac 5k 2021', 'Apple offers an excellent lineup of three 27-inch iMac versions, starting with the entry-level model that includes a 3.1GHz 6-Core 10th-generation Intel Core i5 processor with Turbo Boost up to 4.5GHz', 'product_image-1612611216503.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `productcategorydetail`
--

CREATE TABLE `productcategorydetail` (
  `productId` int(15) NOT NULL,
  `categoryId` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `productcategorydetail`
--

INSERT INTO `productcategorydetail` (`productId`, `categoryId`) VALUES
(2, 3),
(3, 1),
(4, 4),
(5, 4),
(6, 3),
(7, 2);

-- --------------------------------------------------------

--
-- Table structure for table `productdivisiondetail`
--

CREATE TABLE `productdivisiondetail` (
  `productId` int(15) NOT NULL,
  `divisionId` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `productdivisiondetail`
--

INSERT INTO `productdivisiondetail` (`productId`, `divisionId`) VALUES
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1);

-- --------------------------------------------------------

--
-- Table structure for table `productsubcategorydetail`
--

CREATE TABLE `productsubcategorydetail` (
  `productId` int(15) NOT NULL,
  `subCategoryId` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `productsubcategorydetail`
--

INSERT INTO `productsubcategorydetail` (`productId`, `subCategoryId`) VALUES
(2, 6),
(3, 3),
(4, 9),
(5, 8),
(5, 9),
(6, 6),
(7, 4);

-- --------------------------------------------------------

--
-- Table structure for table `subcategory`
--

CREATE TABLE `subcategory` (
  `subCategoryId` int(10) NOT NULL,
  `subCategoryName` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `subcategory`
--

INSERT INTO `subcategory` (`subCategoryId`, `subCategoryName`) VALUES
(1, NULL),
(2, 'Android'),
(3, 'IOS'),
(4, 'Desktop computers'),
(5, 'Laptop Computer'),
(6, 'Teddy Bears'),
(7, 'stuffed dogs'),
(8, 'Remote Control Cars'),
(9, 'Racing cars');

-- --------------------------------------------------------

--
-- Table structure for table `subcategorydetail`
--

CREATE TABLE `subcategorydetail` (
  `categoryId` int(10) NOT NULL,
  `subCategoryId` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `subcategorydetail`
--

INSERT INTO `subcategorydetail` (`categoryId`, `subCategoryId`) VALUES
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(3, 6),
(3, 7),
(4, 8),
(4, 9);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attribute`
--
ALTER TABLE `attribute`
  ADD PRIMARY KEY (`attributeId`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cartId`);

--
-- Indexes for table `cartaddition`
--
ALTER TABLE `cartaddition`
  ADD PRIMARY KEY (`additionId`),
  ADD KEY `cartId` (`cartId`),
  ADD KEY `itemId` (`itemId`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`categoryId`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table ` customercart`
--
ALTER TABLE ` customercart`
  ADD PRIMARY KEY (`customerCartId`),
  ADD KEY `cartId` (`cartId`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `delieveryorder`
--
ALTER TABLE `delieveryorder`
  ADD PRIMARY KEY (`orderId`);

--
-- Indexes for table `division`
--
ALTER TABLE `division`
  ADD PRIMARY KEY (`divisionId`);

--
-- Indexes for table `divisioncategorydetail`
--
ALTER TABLE `divisioncategorydetail`
  ADD PRIMARY KEY (`divisionId`,`categoryId`),
  ADD KEY `categoryId` (`categoryId`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `guest`
--
ALTER TABLE `guest`
  ADD PRIMARY KEY (`guestId`);

--
-- Indexes for table `guest cart`
--
ALTER TABLE `guest cart`
  ADD PRIMARY KEY (`guestCartId`),
  ADD KEY `cartId` (`cartId`),
  ADD KEY `guestId` (`guestId`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`itemId`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `itemdetail`
--
ALTER TABLE `itemdetail`
  ADD PRIMARY KEY (`itemId`,`attributeId`),
  ADD KEY `attributeId` (`attributeId`);

--
-- Indexes for table `maincity`
--
ALTER TABLE `maincity`
  ADD PRIMARY KEY (`cityCode`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`orderId`),
  ADD KEY `Fk` (`cartId`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`orderId`),
  ADD KEY `FK,PK` (`orderId`);

--
-- Indexes for table `pickuporder`
--
ALTER TABLE `pickuporder`
  ADD PRIMARY KEY (`orderId`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`productId`);

--
-- Indexes for table `productcategorydetail`
--
ALTER TABLE `productcategorydetail`
  ADD PRIMARY KEY (`productId`,`categoryId`),
  ADD KEY `categoryId` (`categoryId`);

--
-- Indexes for table `productdivisiondetail`
--
ALTER TABLE `productdivisiondetail`
  ADD PRIMARY KEY (`productId`,`divisionId`),
  ADD KEY `divisionId` (`divisionId`);

--
-- Indexes for table `productsubcategorydetail`
--
ALTER TABLE `productsubcategorydetail`
  ADD PRIMARY KEY (`productId`,`subCategoryId`),
  ADD KEY `subCategoryId` (`subCategoryId`);

--
-- Indexes for table `subcategory`
--
ALTER TABLE `subcategory`
  ADD PRIMARY KEY (`subCategoryId`);

--
-- Indexes for table `subcategorydetail`
--
ALTER TABLE `subcategorydetail`
  ADD PRIMARY KEY (`categoryId`,`subCategoryId`),
  ADD KEY `subCategoryId` (`subCategoryId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attribute`
--
ALTER TABLE `attribute`
  MODIFY `attributeId` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `cartId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `cartaddition`
--
ALTER TABLE `cartaddition`
  MODIFY `additionId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `categoryId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table ` customercart`
--
ALTER TABLE ` customercart`
  MODIFY `customerCartId` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `division`
--
ALTER TABLE `division`
  MODIFY `divisionId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `guest`
--
ALTER TABLE `guest`
  MODIFY `guestId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `guest cart`
--
ALTER TABLE `guest cart`
  MODIFY `guestCartId` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `itemId` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `maincity`
--
ALTER TABLE `maincity`
  MODIFY `cityCode` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81001;

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `orderId` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `productId` int(15) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `subcategory`
--
ALTER TABLE `subcategory`
  MODIFY `subCategoryId` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cartaddition`
--
ALTER TABLE `cartaddition`
  ADD CONSTRAINT `cartaddition_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `cart` (`cartId`),
  ADD CONSTRAINT `cartaddition_ibfk_2` FOREIGN KEY (`itemId`) REFERENCES `item` (`itemId`);

--
-- Constraints for table ` customercart`
--
ALTER TABLE ` customercart`
  ADD CONSTRAINT ` customercart_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `cart` (`cartId`),
  ADD CONSTRAINT ` customercart_ibfk_2` FOREIGN KEY (`email`) REFERENCES `customer` (`email`);

--
-- Constraints for table `delieveryorder`
--
ALTER TABLE `delieveryorder`
  ADD CONSTRAINT `delieveryorder_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`);

--
-- Constraints for table `divisioncategorydetail`
--
ALTER TABLE `divisioncategorydetail`
  ADD CONSTRAINT `divisioncategorydetail_ibfk_2` FOREIGN KEY (`categoryId`) REFERENCES `category` (`categoryId`),
  ADD CONSTRAINT `divisioncategorydetail_ibfk_3` FOREIGN KEY (`divisionId`) REFERENCES `division` (`divisionId`);

--
-- Constraints for table `guest cart`
--
ALTER TABLE `guest cart`
  ADD CONSTRAINT `guest cart_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `cart` (`cartId`),
  ADD CONSTRAINT `guest cart_ibfk_2` FOREIGN KEY (`guestId`) REFERENCES `guest` (`guestId`);

--
-- Constraints for table `item`
--
ALTER TABLE `item`
  ADD CONSTRAINT `item_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`);

--
-- Constraints for table `itemdetail`
--
ALTER TABLE `itemdetail`
  ADD CONSTRAINT `itemdetail_ibfk_1` FOREIGN KEY (`itemId`) REFERENCES `item` (`itemId`),
  ADD CONSTRAINT `itemdetail_ibfk_2` FOREIGN KEY (`attributeId`) REFERENCES `attribute` (`attributeId`);

--
-- Constraints for table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`cartId`) REFERENCES `cart` (`cartId`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`);

--
-- Constraints for table `pickuporder`
--
ALTER TABLE `pickuporder`
  ADD CONSTRAINT `pickuporder_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `order` (`orderId`);

--
-- Constraints for table `productcategorydetail`
--
ALTER TABLE `productcategorydetail`
  ADD CONSTRAINT `productcategorydetail_ibfk_1` FOREIGN KEY (`categoryId`) REFERENCES `category` (`categoryId`),
  ADD CONSTRAINT `productcategorydetail_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`);

--
-- Constraints for table `productdivisiondetail`
--
ALTER TABLE `productdivisiondetail`
  ADD CONSTRAINT `productdivisiondetail_ibfk_1` FOREIGN KEY (`divisionId`) REFERENCES `division` (`divisionId`),
  ADD CONSTRAINT `productdivisiondetail_ibfk_2` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`);

--
-- Constraints for table `productsubcategorydetail`
--
ALTER TABLE `productsubcategorydetail`
  ADD CONSTRAINT `productsubcategorydetail_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`),
  ADD CONSTRAINT `productsubcategorydetail_ibfk_2` FOREIGN KEY (`subCategoryId`) REFERENCES `subcategory` (`subCategoryId`);

--
-- Constraints for table `subcategorydetail`
--
ALTER TABLE `subcategorydetail`
  ADD CONSTRAINT `subcategorydetail_ibfk_1` FOREIGN KEY (`categoryId`) REFERENCES `category` (`categoryId`),
  ADD CONSTRAINT `subcategorydetail_ibfk_2` FOREIGN KEY (`subCategoryId`) REFERENCES `subcategory` (`subCategoryId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
