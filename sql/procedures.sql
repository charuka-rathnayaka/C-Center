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

        IF LENGTH(custom_attribute_names)>0 THEN
        REPEAT SET j = j + 1;
        INSERT INTO  `attribute`(attributeName) VALUES (TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(custom_attribute_names, ',', j), ',', -1)));
        INSERT INTO  `itemdetail`(itemId,attributeId,value) VALUES (item_id, LAST_INSERT_ID(),TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(custom_attribute_values, ',', j), ',', -1)));
        UNTIL j >= num_custom_attributes
        END REPEAT;
        END IF;

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
    
    Id INT(10))
BEGIN
    START TRANSACTION;
        
        INSERT INTO `cart`(`state`) VALUES ("open");
        SELECT @cartId:=MAX(cartId) FROM `cart`;
        INSERT INTO `customercart`(`cartId`, `customerId`) VALUES (@cartId,Id);

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


use c_center_db;
DELIMITER $$
DROP PROCEDURE IF EXISTS `pickup_Order_Iteam`$$
CREATE PROCEDURE `pickup_Order_Iteam`(
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
    select `cartId` INTO idcart from `guest cart` left outer join cart  using(cartId) where `guestId`=customerId and `state`='open' limit 1;
   ELSEIF (userType ="customer") THEN
       select `cartId` INTO idcart from  customercart left outer join cart  using(cartId) where `customerId`=customerId and `state`='open' limit 1;
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
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS `delievery_Order_Iteam`$$
CREATE PROCEDURE `delievery_Order_Iteam`(
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

DELIMITER $$

DROP PROCEDURE IF EXISTS `add_to_cart`$$

CREATE PROCEDURE `add_to_cart`(
    
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
END$$

DELIMITER ;

