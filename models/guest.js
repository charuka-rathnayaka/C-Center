const Database = require("../database/database");
const _database = new WeakMap();
const bcrypt=require("bcryptjs");
const GuestUser=process.env.GuestUser;
const GuestUserPwd=process.env.GuestUserPwd;
class Guest {
    constructor() {
      _database.set(this, new Database(GuestUser,GuestUserPwd));
    }

    //function to create a token id for guest and store it in db
    async get_guest_id() {
        var result = await _database
          .get(this)
          .select_query(
              //check thisssssss
            'Insert INTO `guest` VALUES ();'   
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

}






module.exports = Guest;