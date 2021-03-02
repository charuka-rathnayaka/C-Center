const Database = require("../database/database");
const _database = new WeakMap();
const bcrypt=require("bcryptjs");
const NormalUser=process.env.NormalUser;
const NormalUserPwd=process.env.NormalUserPwd;
class User {
    constructor() {
      _database.set(this, new Database(NormalUser,NormalUserPwd));
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
    
     //Function to get product data of a division to front end
       async get_division_products(divName) {
        var result = await _database
          .get(this)
          .select_query(
             
            'SELECT DISTINCT `product`.`productId`,`product`.productName, `product`.`description`, `product`.`photoLink` FROM `product` NATURAL JOIN `productdivisiondetail` NATURAL JOIN `division` WHERE `division`.`divisionName`="'+divName+'"'  
          );
       
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }

       //Function to get product data of a category to front end
       async get_category_products(id) {
        var result = await _database
          .get(this)
          .select_query(
             
            'SELECT DISTINCT `product`.`productId`,`product`.productName, `product`.`description`, `product`.`photoLink` FROM `product` NATURAL JOIN `productcategorydetail` NATURAL JOIN `category` WHERE `category`.`categoryId`='+id  
          );
       
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }

      //Function to get product data of a sub-category to front end
      async get_sub_category_products(id,catId) {
        var result = await _database
          .get(this)
          .select_query(
             
            'SELECT DISTINCT `product`.`productId`,`product`.productName, `product`.`description`, `product`.`photoLink` FROM `product` NATURAL JOIN `productsubcategorydetail` NATURAL JOIN `subcategory` NATURAL JOIN `productcategorydetail` NATURAL JOIN `category` WHERE `category`.`categoryId`='+catId+' AND `subcategory`.`subCategoryId`='+id 
          );
       
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }


      //function to get the categories of a division
      async get_categories(divName) {
        var result = await _database
          .get(this)
          .select_query(
            'SELECT `category`.`categoryId`, `category`.`categoryName` From `category` NATURAL JOIN `divisioncategorydetail` NATURAL JOIN `division` WHERE `division`.`divisionName`="'+divName+'"'
            
           
          );
       
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }

      //function to get the sub categories of a category
      async get_sub_categories(id) {
        //console.log('id came to this as '+ id);
        var result = await _database
          .get(this)
          .select_query(
            'SELECT `subCategory`.`subCategoryId`, `subCategory`.`subCategoryName` From `subCategory` NATURAL JOIN `subcategorydetail` NATURAL JOIN `category` WHERE `category`.`categoryId`='+id
            
           
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
          
            'select email,password,firstName,role,employeeId as Id from `employee` where email=? union select email,password,firstName,"customer" as role, customerId as Id from `customer` where email=?',
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
  
  

     async showInformation(product_id){
        var result = await _database
          .get(this)
          .select_query(
          
            'SELECT * FROM (SELECT * FROM (SELECT item.productId,item.itemId,attribute.attributeName,itemdetail.value,attribute.attributeId FROM ((item INNER JOIN itemdetail ON item.itemId = itemdetail.itemId) INNER JOIN attribute ON itemdetail.attributeId = attribute.attributeId) ) AS A NATURAL JOIN product)AS B WHERE productId=?',
            [product_id]   
          );
        
        return new Promise((resolve,reject)=>{
            let obj = {
              connectionError: _database.get(this).connectionError,
            }
            result.error ? (obj.error = true) : (obj.result = result.result);
            resolve(obj);
            
        })
      }
      async showItemInformation(item_id){
        var result = await _database
          .get(this)
          .select_query(
          
            'SELECT * FROM (SELECT * FROM (SELECT item.productId,item.itemId,attribute.attributeName,itemdetail.value,attribute.attributeId FROM ((item INNER JOIN itemdetail ON item.itemId = itemdetail.itemId) INNER JOIN attribute ON itemdetail.attributeId = attribute.attributeId) ) AS A NATURAL JOIN product)AS B WHERE itemId=?',
            [item_id]   
          );
        
        return new Promise((resolve,reject)=>{
            let obj = {
              connectionError: _database.get(this).connectionError,
            }
            result.error ? (obj.error = true) : (obj.result = result.result);
            
            resolve(obj);
            
        })
      }
      
     
      async addToCart(cartId,quantity,itemId){
        var result = await _database
          .get(this)
          .call_procedure("add_to_cart",
            [cartId,itemId,quantity]

          );
        
        return new Promise((resolve,reject)=>{
            let obj = {
              connectionError: _database.get(this).connectionError,
            }
            result.error ? (obj.error = true) : (obj.result = result.result);
            
            resolve(obj);
            
        })
      }
      

  async orderIteams(ContactName, contactnumber, pickupdate, payment, custermer_id,usertype) {
    console.log(ContactName, contactnumber, pickupdate, payment, custermer_id, usertype);
    var result = await _database
    .get(this)
    .select_query(
            'CALL pickup_Order_Iteam(?,?,?,?,?,?,?)',
      [usertype,custermer_id,"open",pickupdate,contactnumber,ContactName,payment]   
          );
   
     return new Promise((resolve) => {
          
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
       //console.log(result);
          resolve(obj);
        });
  }
  async delieveryOrderIteam(ContactName, contactnumber, delieveryAddress, city, payment, custermer_id, usertype) {
    console.log(ContactName, contactnumber, delieveryAddress, city, payment, custermer_id, usertype);
    var result = await _database
      .get(this)
      .select_query(
        'CALL delievery_Order_Iteam(?,?,?,?,?,?,?,?)',
        [usertype,custermer_id, "open", delieveryAddress, city, contactnumber, ContactName, payment]
      );
    
    return new Promise((resolve) => {

      let obj = {
        connectionError: _database.get(this).connectionError,
      };
      result.error ? (obj.error = true) : (obj.result = result.result);
      //console.log(result);
      resolve(obj);
    });
  }

  async get_email_details(cartId){
    var result= await _database
      .get(this)
      .select_query(
        `select cartId,itemId,productName,photoLink,count(productId) as quantity,value from cart inner join cartAddition using(cartId) inner join item using(itemId) inner join itemDetail using(itemId) inner join product using(productId) where cartId=? and attributeId=4 group by productId;`,
        [cartId]
      );
    return new Promise((resolve)=>{
      let obj = {
        connectionError: _database.get(this).connectionError,
      };
      result.error ? (obj.error = true) : (obj.result = result.result);
      resolve(obj);
    });
  }


}



module.exports = User;
