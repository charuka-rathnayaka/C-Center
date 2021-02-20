DELIMITER $$

DROP PROCEDURE IF EXISTS `add_new_product`$$

CREATE PROCEDURE `add_new_product`(
    
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
END$$

DELIMITER ;



DELIMITER $$

DROP PROCEDURE IF EXISTS `add_new_item`$$

CREATE PROCEDURE `add_new_item`(
    
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

        REPEAT SET j = j + 1;
        INSERT INTO  `attribute`(attributeName) VALUES (TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(custom_attribute_names, ',', j), ',', -1)));
        INSERT INTO  `itemdetail`(itemId,attributeId,value) VALUES (item_id, LAST_INSERT_ID(),TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(custom_attribute_values, ',', j), ',', -1)));
        UNTIL j >= num_custom_attributes
        END REPEAT;

    COMMIT;
END$$

DELIMITER ;



DELIMITER $$

DROP PROCEDURE IF EXISTS `update_item_count`$$

CREATE PROCEDURE `update_item_count`(
    
    Item_ID int(15),
	NewItemQuantity int(5))
BEGIN
    
    DECLARE ItemQuantity INT(5) DEFAULT 0;
    
    START TRANSACTION;
        
        
        SELECT itemCount INTO ItemQuantity FROM `item` where itemId=Item_ID LIMIT 1;
        SET ItemQuantity = ItemQuantity + NewItemQuantity;
        UPDATE `item` SET itemCount=ItemQuantity WHERE itemId=Item_ID;
      
    COMMIT;
END$$

DELIMITER ;




DELIMITER $$

DROP PROCEDURE IF EXISTS `create_cart_customer`$$

CREATE PROCEDURE `create_cart_customer`(
    
    Email VARCHAR(30))
BEGIN
    START TRANSACTION;
        
        INSERT INTO `cart`(`state`) VALUES ("open");
        SELECT @cartId:=MAX(cartId) FROM `cart`;
        INSERT INTO ` customercart`(`cartId`, `email`) VALUES (@cartId,Email);

    COMMIT;
END$$

DELIMITER ;



DELIMITER $$

DROP PROCEDURE IF EXISTS `create_cart_guest`$$

CREATE PROCEDURE `create_cart_guest`(
    
    Id VARCHAR(30))
BEGIN
    START TRANSACTION;
        
        INSERT INTO `cart`(`state`) VALUES ("open");
        SELECT @cartId:=MAX(cartId) FROM `cart`;
        INSERT INTO `guest cart` (`cartId`, `guestId`) VALUES (@cartId,Id);
        
    COMMIT;
END$$

DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS `pickup_Order_Iteam`$$
CREATE PROCEDURE `pickup_Order_Iteam`(
    
    cartId int(10),
  state varchar(30) ,
     pickupDate date ,
  contactNumber varchar(11) ,
  contactName varchar(50),
  paymentMethod varchar(20)
    )
BEGIN
    DECLARE order_id INT DEFAULT 0;
    START TRANSACTION;
        INSERT INTO `order`(`cartId`, `delieveryMethod`, `state`) VALUES (cartId,'pickuporder',state);
        SET order_id = LAST_INSERT_ID();
        INSERT INTO `pickuporder`(`orderId`, `pickupDate`, `contactNumber`, `contactName`) VALUES (order_id,pickupDate,contactNumber,contactName);
INSERT INTO `payment`(`orderId`, `paymentMethod`) VALUES (order_id,paymentMethod);
UPDATE `cart` SET `dateOfPurchase`=curdate() WHERE `cartId`=cartId;
UPDATE `cart` SET `dateOfPurchase`=curdate() WHERE `cartId`=cartId;
UPDATE item s
JOIN (
   select itemId as itemId , COUNT(itemId) as itemC from cartAddition where cartId=cartId group by itemId
) vals ON s.itemId = vals.itemId
SET itemCount =itemCount- itemC;
    COMMIT;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS `delievery_Order_Iteam`$$
CREATE PROCEDURE `delievery_Order_Iteam`(
    
    cartId int(10),
  state varchar(30) ,
     delieveryAddress varchar(50)	 ,
  city	varchar(20)	 ,
  contactNumber	varchar(11)	,
  contactName	varchar(50)	,
  delieveryEstimate	date,
  paymentMethod varchar(20)
    )
BEGIN
    DECLARE order_id INT DEFAULT 0;
    DECLARE numofItem INT DEFAULT 0;
     DECLARE i INT(8) DEFAULT 0;
    START TRANSACTION;
        INSERT INTO `order`(`cartId`, `delieveryMethod`, `state`) VALUES (cartId,'delieveryorder',state);
        SET order_id = LAST_INSERT_ID();
        INSERT INTO `delieveryorder`(`orderId`, `delieveryAddress`, `city`, `contactNumber`, `contactName`, `delieveryEstimate`) VALUES (order_id,delieveryAddress,city,contactNumber,contactName,delieveryEstimate);
INSERT INTO `payment`(`orderId`, `paymentMethod`) VALUES (order_id,paymentMethod);
UPDATE `cart` SET `dateOfPurchase`=curdate() WHERE `cartId`=cartId;
UPDATE item s
JOIN (
   select itemId as itemId , COUNT(itemId) as itemC from cartAddition where cartId=cartId group by itemId
) vals ON s.itemId = vals.itemId
SET itemCount =itemCount- itemC;

    COMMIT;
END$$
DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `Update_cart_iteam`$$

CREATE PROCEDURE `Update_cart_iteam`(
    
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
END$$

DELIMITER ;

