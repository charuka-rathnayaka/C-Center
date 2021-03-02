const Database = require("../database/database");
const _database = new WeakMap();
const bcrypt = require("bcryptjs");

const SalesManagerUser = process.env.SalesManagerUser;
const SalesManagerPwd = process.env.SalesManagerPwd;

class SalesManager {
  constructor() {
    //console.log(SalesManagerUser,SalesManagerPwd);
    _database.set(this, new Database(SalesManagerUser, SalesManagerPwd));
  }

  //function to get division-category details to frontend
  async get_division_category() {
    var result = await _database
      .get(this)
      .select_query(
        'select `division`.`divisionName`,`division`.`divisionId`,`category`.`categoryName`,`category`.`categoryId` from `division` left join `divisioncategorydetail` on `division`.`divisionId`=`divisioncategorydetail`.`divisionId` left join `category` on `divisioncategorydetail`.`categoryId`=`category`.`categoryId`'

      );

    return new Promise((resolve) => {
      let obj = {
        connectionError: _database.get(this).connectionError,
      };
      result.error ? (obj.error = true) : (obj.result = result.result);
      resolve(obj);
    });
  }

  //Functions to get divisions to front end
  async get_divisions() {
    var result = await _database
      .get(this)
      .select_query(
        'select * from `division`'

      );

    return new Promise((resolve) => {
      let obj = {
        connectionError: _database.get(this).connectionError,
      };
      result.error ? (obj.error = true) : (obj.result = result.result);
      resolve(obj);
    });
  }

  //Function to get category_subcategory data to frontend
  async get_category_subcategory() {
    var result = await _database
      .get(this)
      .select_query(
        'select `category`.`categoryName`,`category`.`categoryId`,`subcategory`.`subCategoryName`,`subcategory`.`subCategoryId` from `category` left join `subcategorydetail` on `category`.`categoryId`=`subcategorydetail`.`categoryId` left join `subcategory` on `subcategorydetail`.`subCategoryId`=`subcategory`.`subCategoryId`'

      );
    // console.log("model",result);
    return new Promise((resolve) => {
      let obj = {
        connectionError: _database.get(this).connectionError,
      };
      result.error ? (obj.error = true) : (obj.result = result.result);
      resolve(obj);
    });
  }

  //Function to add a new product data to db
  async add_new_product(reqbody, stored_image) {
    //console.log(reqbody)
    var product_name = reqbody.product_name;
    var product_desc = reqbody.description;
    var image = stored_image;
    console.log("model", reqbody, image, product_name);
    var division = reqbody.division;
    var num_categories = 0
    var num_sub_categories = 0;
    var categories = "";
    var sub_categories = "";
    var objec;
    for (objec in reqbody) {

      if (objec.substr(0, 3) == 'cat') {

        categories += reqbody[objec];
        categories += ",";
        num_categories += 1;

      }
      else if (objec.substr(0, 3) == 'sub') {
        sub_categories += reqbody[objec];
        sub_categories += ",";
        num_sub_categories += 1;

      }
    }
    var category_list = categories.substring(0, categories.length - 1);
    var sub_category_list = sub_categories.substring(0, sub_categories.length - 1);
    var result = await _database
      .get(this)
      .call_procedure("add_new_product", [
        product_name,
        product_desc,
        image,
        division,
        num_categories,
        category_list,
        num_sub_categories,
        sub_category_list
      ]);

    return new Promise((resolve) => {
      let obj = {
        data: result.result,
        connectionError: _database.get(this).connectionError,
      };
      console.log(result.error);

      result.error ? (obj.error = true) : (obj.error = false);
      resolve(obj);
    });
  }



  async get_annual_sales(year) {
    var result = await _database
      .get(this)
      .select_query(
        'SELECT * FROM `annual_sales` WHERE YEAR(`annual_sales`.`dateOfPurchase`)=?',
        //'SELECT `product`.`productId`, `product`.`productName`,`cart`.`dateOfPurchase`,`itemdetail`.`value` as productSale FROM `order` NATURAL JOIN `cart` RIGHT JOIN `cartaddition` ON `cart`.`cartId`=`cartaddition`.`cartId` LEFT JOIN `item` ON `cartaddition`.`itemId`=`item`.`itemId` NATURAL JOIN `product` LEFT JOIN `itemdetail` on `item`.`itemId`=`itemdetail`.`itemId` where `itemdetail`.`attributeId`=4 AND YEAR(`cart`.`dateOfPurchase`)=?',
        [year]
      );
    return new Promise((resolve) => {
      let obj = {
        connectionError: _database.get(this).connectionError,
      };

      if (result.error == true) {
        obj.error = true
      }
      else {

        function get_quarter(date) {
          var month = (date).getMonth() + 1;
          var quarter;

          if ((1 <= month) && (month < 3)) {
            quarter = "quarter1";
          }
          else if ((3 <= month) && (month < 6)) {
            quarter = "quarter2";
          }
          else if ((6 <= month) && (month < 9)) {
            quarter = "quarter3";
          }
          else {
            quarter = "quarter4";
          }

          return quarter;
        }
        obj.result = result.result;
        var db_result = result.result;



        var sales_data = [];

        for (var j = 0; j < db_result.length; j++) {

          var is_prod_insert = false;
          for (var i = 0; i < sales_data.length; i++) {

            if (sales_data[i]["productId"] == db_result[j].productId) {
              is_prod_insert = true;
              sales_data[i].productSale = sales_data[i].productSale + parseFloat(db_result[j].productSale);
              var quarter = get_quarter(db_result[j].dateOfPurchase);

              sales_data[i].quarters[quarter] = sales_data[i].quarters[quarter] + parseFloat(db_result[j].productSale);

            }
          }
          if (is_prod_insert == false) {
            var json_data = { "productId": db_result[j].productId, "productName": db_result[j].productName, "productSale": parseFloat(db_result[j].productSale), "quarters": { "quarter1": 0, "quarter2": 0, "quarter3": 0, "quarter4": 0 } };
            var quarter = get_quarter(db_result[j].dateOfPurchase);
            json_data.quarters[quarter] = parseFloat(db_result[j].productSale);
            sales_data.push(json_data);
          }
        }

        obj.result = sales_data;
      }
      resolve(obj);
    });
  }


  async get_most_saled_products(startdate, enddate) {
    var result = await _database
      .get(this)
      .select_query(
        // "SELECT `top_products` where `itemdetail`.`attributeId`=4 AND (DATE(`cartaddition`.`dateOfAddition`) BETWEEN ? AND ?)",
        "SELECT `product`.`productId`, `product`.`productName`,COUNT(`item`.`itemId`) as productQuantity,SUM(`itemdetail`.`value`) as productSale FROM `order` left JOIN `cart` on `order`.`cartId`=`cart`.`cartId` RIGHT JOIN `cartaddition` ON `cart`.`cartId`=`cartaddition`.`cartId` LEFT JOIN `item` ON `cartaddition`.`itemId`=`item`.`itemId` NATURAL JOIN `product` LEFT JOIN `itemdetail` on `item`.`itemId`=`itemdetail`.`itemId` where `itemdetail`.`attributeId`=4 AND (DATE(`cartaddition`.`dateOfAddition`) BETWEEN ? AND ?) GROUP BY `product`.`productId` ORDER BY productQuantity desc LIMIT 10",
        [startdate, enddate]
      );

    return new Promise((resolve) => {
      let obj = {
        connectionError: _database.get(this).connectionError,
      };
      result.error ? (obj.error = true) : (obj.result = result.result);
      resolve(obj);
    });
  }

  async get_most_saled_categories() {
    var result = await _database
      .get(this)
      .select_query(
        "SELECT * FROM `top_categories`;",
      );
    return new Promise((resolve) => {
      let obj = {
        connectionError: _database.get(this).connectionError,
      };
      result.error ? (obj.error = true) : (obj.result = result.result);
      resolve(obj);
    });
  }

  async get_most_prefer_period(product_id) {
    var result = await _database
      .get(this)
      .select_query(
        "SELECT * FROM `most_prefer_period` WHERE `productId`=?",
        // "SELECT `product`.`productId`,`product`.`productName`,SUM(`itemdetail`.`value`) as productSale,count(`item`.`itemId`) as saleQuantity,DATE_FORMAT(`cartaddition`.`dateOfAddition`, '%m-%Y') as monthYear FROM `order` NATURAL JOIN `cart` RIGHT JOIN `cartaddition` ON `cart`.`cartId`=`cartaddition`.`cartId` LEFT JOIN `item` ON `cartaddition`.`itemId`=`item`.`itemId` NATURAL JOIN `product` LEFT JOIN `itemdetail` on `item`.`itemId`=`itemdetail`.`itemId` where `itemdetail`.`attributeId`=4 AND `product`.`productId`=? GROUP by `product`.`productId`,Month(`cartaddition`.`dateOfAddition`), Year(`cartaddition`.`dateOfAddition`) ORDER BY `saleQuantity` DESC LIMIT 5",
        [product_id]
      );

    return new Promise((resolve) => {
      let obj = {
        connectionError: _database.get(this).connectionError,
      };
      result.error ? (obj.error = true) : (obj.result = result.result);
      resolve(obj);
    });
  }


  async get_customer_order(email) {
    var result = await _database
      .get(this)
      .select_query(
        "SELECT * FROM `customer_orders` WHERE `email`=?",
        //"SELECT `customer`.`email`,`customer`.`firstName`,`customer`.`lastName`,`cart`.`cartId`,`product`.`productId`, `product`.`productName`,`item`.`itemId`,`cart`.`dateOfPurchase`,`itemdetail`.`value` as productSale FROM `order` NATURAL JOIN `cart` RIGHT JOIN `cartaddition` ON `cart`.`cartId`=`cartaddition`.`cartId` LEFT JOIN `customercart` on `cart`.`cartId`=`customercart`.`cartId` LEFT join `customer` on `customercart`.`customerId`=`customer`.`customerId` LEFT JOIN `item` ON `cartaddition`.`itemId`=`item`.`itemId` NATURAL JOIN `product` LEFT JOIN `itemdetail` on `item`.`itemId`=`itemdetail`.`itemId` where `itemdetail`.`attributeId`=4 and `customer`.`email`=?",
        [email]
      );

    return new Promise((resolve) => {
      let obj = {
        connectionError: _database.get(this).connectionError,
      };
      if (result.error == true) {
        obj.error = true
      }
      else {
        obj.result = result.result;
        var db_result = result.result;
        var data_out = { "customer_data": {}, "carts": [] }
        if (db_result.length > 0) {
          data_out.customer_data["email"] = db_result[0].email;
          data_out.customer_data["fullName"] = db_result[0].firstName + " " + db_result[0].lastName;
          for (var j = 0; j < db_result.length; j++) {

            var is_cart_insert = false;
            for (var i = 0; i < data_out.carts.length; i++) {
              if (data_out.carts[i].cart_details["cartId"] == db_result[j].cartId) {
                is_cart_insert = true;
                (data_out.carts[i].cart_items).push({ "productId": db_result[j].productId, "productName": db_result[j].productName, "itemId": db_result[j].itemId, "productSale": db_result[j].productSale });
              }
            }
            if (is_cart_insert == false) {
              var moment = require("moment");
              var purchasedate = (moment(db_result[j].dateOfPurchase).format("MMM Do YY"));
              var json_data = { "cart_details": { "cartId": db_result[j].cartId, "dateOfPurchase": purchasedate }, "cart_items": [{ "productId": db_result[j].productId, "productName": db_result[j].productName, "itemId": db_result[j].itemId, "productSale": db_result[j].productSale }] };
              data_out.carts.push(json_data);
            }

          }
        }

        obj.result = data_out;
      }
      resolve(obj);
    });
  }





}




module.exports = SalesManager;