const Database = require("../database/database");
const _database = new WeakMap();
const bcrypt=require("bcryptjs");

class User {
    constructor() {
      _database.set(this, new Database());
    }

//Function to log the user in. This is common to all users
    async login(email) {
        var result = await _database
          .get(this)
          .select_query(
            'select email,password,role from `employee` where email=? union select email,password,"customer" as role from `customer` where email=?',
            [email,email]
           
          );
    
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }



      //Function to get new products data to fronend home page
      async get_new_products(email) {
        var result = await _database
          .get(this)
          .select_query(
            'SELECT * From product ORDER BY productId DESC LIMIT 10'
            
           
          );
       
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }

        //Function to get trending product data to frront end
      async get_trending_products(email) {
        var result = await _database
          .get(this)
          .select_query(
             
            'SELECT DISTINCT `product`.`productId`,`product`.productName, `product`.`description`, `product`.`photoLink`, COUNT(`cartaddition`.`additionId`) as Product_count FROM `cartaddition` NATURAL JOIN `item` NATURAL JOIN `product` GROUP BY `product`.`productId` ORDER BY Product_count DESC LIMIT 10'   
          );
       
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }

        //function for the middlewware getting user basic data through token
      async get_user(email) {
        var result = await _database
          .get(this)
          .select_query(
          
            'select email,password,firstName,role from `employee` where email=? union select email,password,firstName,"customer" as Role from `customer` where email=?',
            [email,email]   
          );
     
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
  }
  
  async orderIteams(ContactName, contactnumber,pickupdate,payment,Cart_ID) {
        var result = await _database
          .get(this)
          .select_query(
          
            'CALL pickup_Order_Iteam(?,?,?,?,?,?)',
            [Cart_ID,"notDelivered",pickupdate,contactnumber,ContactName,payment]   
          );
      console.log(ContactName, contactnumber,pickupdate,payment);
     return new Promise((resolve) => {
          
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
         
          resolve(obj);
        });
  }
 

}

module.exports = User;