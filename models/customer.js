const Database = require("../database/database");
const _database = new WeakMap();
const bcrypt=require("bcryptjs");
const CustomerUser=process.env.CustomerUser;
const CustomerUserPwd=process.env.CustomerUserPwd;


class Customer {
    constructor() {
      _database.set(this, new Database(CustomerUser,CustomerUserPwd));
    }

    //function to get customer profile details to profile page
    async get_customer_profile(email) {
        var result = await _database
          .get(this)
          .select_query(
            'SELECT * From customer natural join maincity WHERE email=?',
            [email] 
          );
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }

      
      //Function to check whether the input email is previously used
      async register_check(email) {
        var result = await _database
          .get(this)
          .select_query(
            'SELECT email From customer WHERE email=? union SELECT email From employee WHERE email=?',
            [email,email]
           
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


      //Function to register customers
      async register_insert(firstname,lastname,email,address,city,birthday,contactnumber,password) {
        //console.log('register model')
        const salt= await bcrypt.genSalt();
        let hashedpassword= await bcrypt.hash(password,salt);
        var result = await _database
          .get(this)
          .select_query(
            'INSERT INTO customer (email,firstName,lastName,address,cityCode,dateOfBirth,contactNumber,password) values (?,?,?,?,?,?,?,?)',
            [email,firstname,lastname, address,city, birthday,contactnumber,hashedpassword]
           
          );
        //console.log("model",result);
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }

      async get_cities() {
        var result = await _database
          .get(this)
          .select_query(
            'select * from `maincity`'
            
          );
       
        return new Promise((resolve) => {
          let obj = {
            connectionError: _database.get(this).connectionError,
          };
          result.error ? (obj.error = true) : (obj.result = result.result);
          resolve(obj);
        });
      }
      async createCart(Id){
        
        var result = await _database
          .get(this)
          .call_procedure("create_cart_customer",
            [Id]
          );
          
          
          
          return new Promise((resolve,reject)=>{
            let obj = {
              connectionError: _database.get(this).connectionError,
            }
              result.error ? (obj.error = true) : (obj.result = result.result);
              resolve(obj);
    
          })
  
        
                
      }
     
      async checkCart(Id){
        var result = await _database
          .get(this)
          .select_query(
            'SELECT MAX(cartId) AS cartid FROM `customercart` NATURAL JOIN `cart` WHERE customerId=? AND state="open"',
            [Id]
          );
          
          return new Promise((resolve) => {
            let obj = {
              connectionError: _database.get(this).connectionError,
            };
            result.error ? (obj.error = true) : (obj.result = result.result);
            resolve(obj);
          });
      }
      async getCartId(Id){
        
        var result=await _database
        .get(this)
        .select_query(
          'SELECT max(cartId) AS cartid FROM customercart WHERE customerId=?  ',
          [Id]
        );
        
        return new Promise((resolve,reject)=>{
          let obj = {
            connectionError: _database.get(this).connectionError,
          }
          result.error ? (obj.error = true) : (obj.result = result.result);
                  
          resolve(obj);
                  
        })

      }


}

module.exports = Customer;