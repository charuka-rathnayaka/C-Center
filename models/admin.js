const Database = require("../database/database");
const _database = new WeakMap();
const bcrypt=require("bcryptjs");

const AdminUser=process.env.AdminUser;
const AdminUserPwd=process.env.AdminUserPwd;


class Admin {
    constructor() {
      _database.set(this, new Database(AdminUser,AdminUserPwd));
    }

        //Function check the employee email is previously used
      async employee_register_check(email) {
        var result = await _database
          .get(this)
          .select_query(
            'SELECT email From customer WHERE email=? union SELECT email From employee WHERE email=?',
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

      //function to insert new employee details to db
      async employee_register_insert(firstname,lastname,email,recruitment_day,role,birthday,contactnumber,password) {
        const salt= await bcrypt.genSalt();
        let hashedpassword= await bcrypt.hash(password,salt);
        var result = await _database
          .get(this)
          .select_query(
            'INSERT INTO employee SET ?',
            {email:email,firstName:firstname,lastName:lastname, role:role, dateOfRecruitment:recruitment_day, dateOfBirth:birthday,telephoneNumber:contactnumber, password:hashedpassword}
           
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

module.exports = Admin;