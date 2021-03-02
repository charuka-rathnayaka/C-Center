const Database = require("../database/database");
const _database = new WeakMap();
const bcrypt=require("bcryptjs");
const WareHouseOfficerUser=process.env.WareHouseOfficerUser;
const WareHouseOfficerPwd=process.env.WareHouseOfficerPwd;
class WarehouseOfficer {
    constructor() {
      _database.set(this, new Database(WareHouseOfficerUser,WareHouseOfficerPwd));
    }


    //Function to get registerd attributes to front end for adding a new item
    async get_attributes(email) {
        var result = await _database
          .get(this)
          .select_query(
            'select * from `attribute`'
            
          );
       
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }

//Function to add new item to database
      async add_new_item(reqbody) {
        var product_id=reqbody.product_id;
        var product_quantity=reqbody.quantity;
        var common_attribute_values="";
        var common_attributes="";
        var num_common_attributes=1;
        var num_custom_attributes=0;
        common_attributes+="4,";
        common_attribute_values+=reqbody.price;
        common_attribute_values+=",";
        var attr;
      
        var custom_attributes="";
        var custom_attribute_values="";
        var ele;
        for (ele in reqbody){
            if((reqbody[ele]).length>0){
                if(ele.substr(0,15)=='attribute_value'){
                    common_attributes+=reqbody.attributes[num_common_attributes-1];
                    common_attributes+=",";
                    common_attribute_values+=reqbody[ele];
                    common_attribute_values+=",";
                    num_common_attributes+=1;
                }
                else if(ele.substr(0,16)=='custom_attribute'){
                    if((reqbody['custome_attribute_value'+ele.substr(16,17)]).length>0){
                        if((reqbody[ele].length>0)&&reqbody['custome_attribute_value'+ele.substr(16,17)].length>0){
                            custom_attributes+=reqbody[ele];
                            custom_attributes+=",";
                            custom_attribute_values+=reqbody['custome_attribute_value'+ele.substr(16,17)];
                            custom_attribute_values+=",";
                            num_custom_attributes+=1;
                        }
                    }
                  
                }
            }
        }
        common_attributes=common_attributes.substring(0, common_attributes.length-1);
        common_attribute_values=common_attribute_values.substring(0, common_attribute_values.length-1);
        if(custom_attributes.length>0){
        custom_attributes=custom_attributes.substring(0, custom_attributes.length-1);
        custom_attribute_values=custom_attribute_values.substring(0, custom_attribute_values.length-1);
        }
        //console.log("custom",custom_attributes,custom_attribute_values);
        var result = await _database
        .get(this)
        .call_procedure("add_new_item", [
                product_id ,
                product_quantity,
                num_common_attributes,
                common_attributes,
                common_attribute_values,
                num_custom_attributes,
                custom_attributes,
                custom_attribute_values
            ]);
        
            return new Promise((resolve) => {
                let obj = {
                data: result.result,
                connectionError: _database.get(this).connectionError,
                };
                
                result.error ? (obj.error = true) : (obj.error = false);
                resolve(obj);
            });
        }
    


//FUnction to update item count of an item
        async update_item_count(item_id,item_quantity) {
           
            var result = await _database
            .get(this)
            .call_procedure("update_item_count", [
                item_id,item_quantity
                ]);
            
                return new Promise((resolve) => {
                    let obj = {
                    data: result.result,
                    connectionError: _database.get(this).connectionError,
                    };
                    
                    result.error ? (obj.error = true) : (obj.error = false);
                    resolve(obj);
                });
            }


            async get_open_orders() {
              var result = await _database
                .get(this)
                .select_query(
                  "SELECT `order`.`orderId`,`cart`.`cartId`,`order`.`delieveryMethod`,`cart`.`dateOfPurchase`,`order`.`state` FROM `order` left JOIN `cart` on `cart`.`cartId`=`order`.`cartId` where `order`.`state`='open';"
                  
                );
             
              return new Promise((resolve) => {
                let obj = {
                  connectionError: _database.get(this).connectionError,
                };
               // result.error ? (obj.error = true) : (obj.result = result.result);
               if (result.error==true){
                obj.error = true
              }
              else{
                var moment = require("moment");
                var db_result=result.result;
                for (var i=0;i<db_result.length;i++){
                  var purchasedate=(moment(db_result[i].dateOfPurchase).format("MMM Do YY"));
                  db_result[i]["dateOfPurchase"]=purchasedate;
                }
                //console.log(db_result);
                obj.result=db_result;

              }
                resolve(obj);
              });
            }


            async get_order_details(orderId) {
              var result = await _database
                .get(this)
                .select_query(
                  "SELECT `cart`.`cartId`,`order`.`state`,`order`.`orderId`,`order`.`delieveryMethod`,`product`.`productId`, `product`.`productName`,`item`.`itemId`,`cartaddition`.`dateOfAddition`,`itemdetail`.`value` as productSale FROM `order` left JOIN `cart` on `order`.`cartId`=`cart`.`cartId` RIGHT JOIN `cartaddition` ON `cart`.`cartId`=`cartaddition`.`cartId` LEFT JOIN `item` ON `cartaddition`.`itemId`=`item`.`itemId` NATURAL JOIN `product` LEFT JOIN `itemdetail` on `item`.`itemId`=`itemdetail`.`itemId` where `itemdetail`.`attributeId`=4 and `order`.`orderId`=?;",
                  [orderId]
                );
             
              return new Promise((resolve) => {
                let obj = {
                  connectionError: _database.get(this).connectionError,
                };
               // result.error ? (obj.error = true) : (obj.result = result.result);
               if (result.error==true){
                obj.error = true
              }
              else{
                var moment = require("moment");
                var db_result=result.result;
                for (var i=0;i<db_result.length;i++){
                  var purchasedate=(moment(db_result[i].dateOfAddition).format("MMM Do YY"));
                  db_result[i]["dateOfAddition"]=purchasedate;
                }
                //console.log(db_result);
                obj.result=db_result;

              }
                resolve(obj);
              });
            }


            async confirm_order(orderId) {
              var result = await _database
                .get(this)
                .select_query(
                  "UPDATE `order` SET `state`='close' WHERE `orderId`=?;",
                  [orderId]
                  
                );
             
              return new Promise((resolve) => {
                let obj = {
                  connectionError: _database.get(this).connectionError,
                };
                result.error ? (obj.error = true) : (obj.result = result.result);
                resolve(obj);
              });
            }

            async get_order(orderId) {
              var result = await _database
                .get(this)
                .select_query(
                  "SELECT `order`.`orderId`,`cart`.`cartId`,`order`.`delieveryMethod`,`cart`.`dateOfPurchase`,`order`.`state` FROM `order` left JOIN `cart` on `order`.`cartId`=`cart`.`cartId` where `order`.`orderId`=?",
                  [orderId]
                  
                );
             
              return new Promise((resolve) => {
                let obj = {
                  connectionError: _database.get(this).connectionError,
                };
                if (result.error==true){
                  obj.error = true
                }
                else{
                  var moment = require("moment");
                  var db_result=result.result;
                  for (var i=0;i<db_result.length;i++){
                    var purchasedate=(moment(db_result[i].dateOfPurchase).format("MMM Do YY"));
                    db_result[i]["dateOfPurchase"]=purchasedate;
                  }
                  //console.log(db_result);
                  obj.result=db_result;
  
                }
                  
                resolve(obj);
              });
            }





}

module.exports = WarehouseOfficer;