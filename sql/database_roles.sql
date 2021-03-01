DROP ROLE IF EXISTS 'user_role';
DROP ROLE IF EXISTS 'admin_role';
DROP ROLE IF EXISTS 'guest_role';
DROP ROLE IF EXISTS 'customer_role';
DROP ROLE IF EXISTS 'sales_manager_role';
DROP ROLE IF EXISTS 'warehouse_officer_role';

DROP USER IF EXISTS 'normal_user'@'localhost';
DROP USER IF EXISTS 'admin_user'@'localhost';
DROP USER IF EXISTS 'guest_user'@'localhost';
DROP USER IF EXISTS 'customer_user'@'localhost';
DROP USER IF EXISTS 'sales_manager_user'@'localhost';
DROP USER IF EXISTS 'warehouse_officer_user'@'localhost';

CREATE USER 'normal_user'@'localhost' IDENTIFIED BY '1111';
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY '1111';
CREATE USER 'guest_user'@'localhost' IDENTIFIED BY '1111';
CREATE USER 'customer_user'@'localhost' IDENTIFIED BY '1111';
CREATE USER 'sales_manager_user'@'localhost' IDENTIFIED BY '1111';
CREATE USER 'warehouse_officer_user'@'localhost' IDENTIFIED BY '1111';

CREATE ROLE 'user_role';
CREATE ROLE 'admin_role';
CREATE ROLE 'guest_role';
CREATE ROLE 'customer_role';
CREATE ROLE 'sales_manager_role';
CREATE ROLE 'warehouse_officer_role';

GRANT 'user_role' TO 'normal_user'@'localhost';
GRANT 'admin_role' TO 'admin_user'@'localhost';
GRANT 'guest_role' TO 'guest_user'@'localhost';
GRANT 'customer_role' TO 'customer_user'@'localhost';
GRANT 'sales_manager_role' TO 'sales_manager_user'@'localhost';
GRANT 'warehouse_officer_role' TO 'warehouse_officer_user'@'localhost';


GRANT SELECT ON `c_center_db`.`customer` TO 'user_role';
GRANT SELECT ON `c_center_db`.`employee` TO 'user_role';
GRANT SELECT ON `c_center_db`.`product` TO 'user_role';
GRANT SELECT ON `c_center_db`.`cartaddition` TO 'user_role';
GRANT SELECT ON `c_center_db`.`item` TO 'user_role';
GRANT SELECT ON `c_center_db`.`itemdetail` TO 'user_role';
GRANT SELECT ON `c_center_db`.`attribute` TO 'user_role';

GRANT SELECT ON `c_center_db`.`customercart` TO 'user_role';
GRANT SELECT ON `c_center_db`.`cart` TO 'user_role';
GRANT DELETE ON `c_center_db`.`cartaddition` TO 'user_role';
GRANT INSERT ON `c_center_db`.`cartaddition` TO 'user_role';
GRANT SELECT ON `c_center_db`.`guest cart` TO 'user_role';
GRANT EXECUTE ON PROCEDURE `c_center_db`.`add_to_cart` TO 'user_role';



GRANT SELECT ON `c_center_db`.`customer` TO 'admin_role';
GRANT SELECT ON `c_center_db`.`employee` TO 'admin_role';
GRANT INSERT ON `c_center_db`.`employee` TO 'admin_role';


GRANT SELECT ON `c_center_db`.`customer` TO 'customer_role';
GRANT SELECT ON `c_center_db`.`employee` TO 'customer_role';
GRANT INSERT ON `c_center_db`.`customer` TO 'customer_role';
GRANT SELECT ON `c_center_db`.`maincity` TO 'customer_role';
GRANT SELECT ON `c_center_db`.`cart` TO 'customer_role';
GRANT SELECT ON `c_center_db`.`customercart` TO 'customer_role';
GRANT INSERT ON `c_center_db`.`cart` TO 'customer_role';
GRANT INSERT ON `c_center_db`.`customercart` TO 'customer_role';
GRANT EXECUTE ON PROCEDURE `c_center_db`.`create_cart_customer` TO 'customer_role';


GRANT INSERT ON `c_center_db`.`guest` TO 'guest_role';
GRANT INSERT ON `c_center_db`.`cart` TO 'guest_role';
GRANT INSERT ON `c_center_db`.`guest cart` TO 'guest_role';
GRANT SELECT ON `c_center_db`.`guest cart` TO 'guest_role';
GRANT SELECT ON `c_center_db`.`cart` TO 'guest_role';
GRANT EXECUTE ON PROCEDURE `c_center_db`.`create_cart_guest` TO 'guest_role';


GRANT SELECT ON `c_center_db`.`division` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`divisioncategorydetail` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`category` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`divisioncategorydetail` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`subcategorydetail` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`subcategory` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`order` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`cart` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`item` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`product` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`itemdetail` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`cartaddition` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`productcategorydetail` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`customercart` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`customer` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`top_categories` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`annual_sales` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`most_prefer_period` TO 'sales_manager_role';
GRANT SELECT ON `c_center_db`.`customer_orders` TO 'sales_manager_role';
GRANT EXECUTE ON PROCEDURE `c_center_db`.`add_new_product` TO 'sales_manager_role';


GRANT SELECT ON `c_center_db`.`attribute` TO 'warehouse_officer_role';
GRANT SELECT ON `c_center_db`.`order` TO 'warehouse_officer_role';
GRANT SELECT ON `c_center_db`.`cart` TO 'warehouse_officer_role';
GRANT SELECT ON `c_center_db`.`cartaddition` TO 'warehouse_officer_role';
GRANT SELECT ON `c_center_db`.`item` TO 'warehouse_officer_role';
GRANT SELECT ON `c_center_db`.`product` TO 'warehouse_officer_role';
GRANT SELECT ON `c_center_db`.`itemdetail` TO 'warehouse_officer_role';
GRANT UPDATE ON `c_center_db`.`order` TO 'warehouse_officer_role';
GRANT EXECUTE ON PROCEDURE `c_center_db`.`add_new_item` TO 'warehouse_officer_role';
GRANT EXECUTE ON PROCEDURE `c_center_db`.`update_item_count` TO 'warehouse_officer_role';

GRANT SELECT ON `c_center_db`.`product` TO 'user_role';
GRANT SELECT ON `c_center_db`.`productdivisiondetail` TO 'user_role';
GRANT SELECT ON `c_center_db`.`division` TO 'user_role';
GRANT SELECT ON `c_center_db`.`productcategorydetail` TO 'user_role';
GRANT SELECT ON `c_center_db`.`category` TO 'user_role';
GRANT SELECT ON `c_center_db`.`productsubcategorydetail` TO 'user_role';
GRANT SELECT ON `c_center_db`.`subcategory` TO 'user_role';
GRANT SELECT ON `c_center_db`.`divisioncategorydetail` TO 'user_role';
GRANT SELECT ON `c_center_db`.`subcategorydetail` TO 'user_role';

GRANT EXECUTE ON PROCEDURE `c_center_db`.`pickup_Order_Iteam` TO 'user_role';
GRANT EXECUTE ON PROCEDURE `c_center_db`.`delievery_Order_Iteam` TO 'user_role';
GRANT EXECUTE ON PROCEDURE `c_center_db`.`Update_cart_iteam` TO 'user_role';
GRANT SELECT ON `c_center_db`.`order` TO 'user_role';
GRANT SELECT ON `c_center_db`.`delieveryorder` TO 'user_role';
GRANT SELECT ON `c_center_db`.`pickuporder` TO 'user_role';
GRANT SELECT ON `c_center_db`.`payment` TO 'user_role';
GRANT INSERT ON `c_center_db`.`order` TO 'user_role';
GRANT INSERT ON `c_center_db`.`delieveryorder` TO 'user_role';
GRANT INSERT ON `c_center_db`.`pickuporder` TO 'user_role';
GRANT INSERT ON `c_center_db`.`payment` TO 'user_role';
GRANT UPDATE ON `c_center_db`.`item` TO 'user_role';

SET DEFAULT ROLE ALL TO 'normal_user'@'localhost','admin_user'@'localhost','guest_user'@'localhost','customer_user'@'localhost','sales_manager_user'@'localhost','warehouse_officer_user'@'localhost';

ALTER USER 'normal_user'@'localhost' IDENTIFIED WITH mysql_native_password BY '1111';
ALTER USER 'admin_user'@'localhost' IDENTIFIED WITH mysql_native_password BY '1111';
ALTER USER 'guest_user'@'localhost' IDENTIFIED WITH mysql_native_password BY '1111';
ALTER USER 'customer_user'@'localhost' IDENTIFIED WITH mysql_native_password BY '1111';
ALTER USER 'sales_manager_user'@'localhost' IDENTIFIED WITH mysql_native_password BY '1111';
ALTER USER 'warehouse_officer_user'@'localhost' IDENTIFIED WITH mysql_native_password BY '1111';



