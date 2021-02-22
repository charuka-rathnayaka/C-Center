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
            'SELECT * From customer WHERE email=?',
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
        let hashedpassword= await bcrypt.hash(password,8);
        var result = await _database
          .get(this)
          .select_query(
            'INSERT INTO customer SET ?',
            {email:email,firstName:firstname,lastName:lastname, address:address, city:city, dateOfBirth:birthday,contactNumber:contactnumber, password:hashedpassword}
           
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


}

module.exports = Customer;