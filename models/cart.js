const Database = require("../database/database");
const _database = new WeakMap();
const NormalUser=process.env.NormalUser;
const NormalUserPwd=process.env.NormalUserPwd;
class Cart{
    constructor(){
        _database.set(this, new Database(NormalUser,NormalUserPwd));
        this.tableName="";
    }

    
  
      async getItemDetail(itemId){
        var result= await _database
          .get(this)
          .select_query(
            `select itemId,value,attributeName from item inner join itemDetail using(itemId) inner join attribute using(attributeID) where itemId=?`,
            [itemId]
          );
        return new Promise((resolve)=>{
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }
  
      async RemoveCartItem(itemId,cartId,val){
        var result= await _database
          .get(this)
          .select_query(
            `delete from cartAddition where itemId=? and cartId=? order by dateOfAddition desc limit ?;`,
            [itemId,cartId,val]
          );
        return new Promise((resolve)=>{
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }
  
      async addCartItem(itemId,cartId){
        var result= await _database
          .get(this)
          .select_query(
            `insert into cartAddition(cartId,itemId,dateOfAddition) values(?,?,curdate());`,
            [cartId,itemId]
          );
        return new Promise((resolve)=>{
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }
  
      async getItemCount(itemId,cartId){
        var result= await _database
          .get(this)
          .select_query(
            `select count(itemId) as "count" from cartAddition where itemId=? and cartId=?;`,
            [itemId,cartId]
          );
        return new Promise((resolve)=>{
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }
      async UpdateItemCount(itemId,cartId,value){
        var result= await _database
          .get(this)
          .select_query(
            `Call Update_cart_iteam(?,?,?)`,
            [itemId,cartId,value]
          );
        return new Promise((resolve)=>{
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }
      async getPrice(itemId){
        var result= await _database
          .get(this)
          .select_query(
            `select value from item inner join itemDetail using(itemId) inner join attribute using(attributeID) where itemId=? and attributeName='Price';;`,
            [itemId]
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

class CustomerCart extends Cart{
    constructor(){
        super();
        this.tableName="customercart";
    }
    async getCartAdditions(customerId){
        var result= await _database
          .get(this)
          .select_query(
            `select itemId,productName,photoLink,cartId,count(itemId) as "count",dateOfAddition from ${this.tableName} left outer join cart using(cartId) inner join cartAddition using(cartId) inner join item using(itemId) inner join product using(productId) where customerId=? and state='open' group by itemId order by dateOfAddition desc;`,
            [customerId]
          );
        return new Promise((resolve)=>{
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
    }

  async getCartAdditionsHistory(customerId) {
    var result = await _database
      .get(this)
      .select_query(
        `select  pickupDate,delieveryEstimate,cart.cartId,count(itemId) as "count",dateOfPurchase from ${this.tableName} left outer join cart on(cart.cartId=customercart.cartId) inner join c_center_db.order on(cart.cartId=c_center_db.order.cartId) left outer join delieveryorder using(orderId) left outer join pickuporder using(orderId) inner join cartAddition on(cartAddition.cartId=cart.cartId) inner join item using(itemId) inner join product using(productId) where customerId=? and cart.state='close' group by cart.cartId order by dateOfPurchase desc;`,
          [customerId]
        );
      return new Promise((resolve)=>{
        let obj = {
          connectionError: _database.get(this).connectionError,
        };
        result.error ? (obj.error = true) : (obj.result = result.result);
        resolve(obj);
      });
    }
    async getItemHistory(customerId,cartId){
      var result= await _database
        .get(this)
        .select_query(
          `select itemId,productName,photoLink,cartId,count(itemId) as "count",dateOfAddition,dateOfPurchase from ${this.tableName} left outer join cart using(cartId) inner join cartAddition using(cartId) inner join item using(itemId) inner join product using(productId) where customerId=? and state='close' and cartId=? group by itemId,cartId order by dateOfAddition desc;`,
          [customerId,cartId]
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

class GuestCart extends Cart{
    constructor(){
        super();
        this.tableName="`guest cart`";
    }
    async getCartAdditions(guestId){
        var result= await _database
          .get(this)
          .select_query(
            `select itemId,productName,photoLink,cartId,count(itemId) as "count",dateOfAddition from ${this.tableName} left outer join cart using(cartId) inner join cartAddition using(cartId) inner join item using(itemId) inner join product using(productId) where guestId=? and state='open' group by itemId order by dateOfAddition desc;`,
            [guestId]
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

module.exports={Cart,CustomerCart,GuestCart};