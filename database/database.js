const mysql = require("mysql");
const _pool = new WeakMap();
const _connectionError = new WeakMap();
const _getResults = new WeakMap();

class Database {
  constructor() {
    try {
      _pool.set(this, mysql.createPool(
        {
            host: process.env.database_host,
            //port: config.mysql.port,
            user:process.env.database_user,
            password : process.env.database_pwd,
            database : process.env.database,
            connectionLimit : 10,
           
          }
      ));
      _connectionError.set(this, false);
    } catch (ex) {
      _connectionError.set(this, true);
    }

    _getResults.set(this, (error, results) => {
      if (error) {
        return { error: true };
      }
      return { error: false, result: results };
    });
  }

  get connectionError() {
    return _connectionError.get(this);
  }



//Use this function only a single query is needed to be executed
  select_query(query_name, values) {
    return new Promise((resolve) => {
      _pool
        .get(this)
        .query(query_name, values, (error, results, fields) => {
          resolve(_getResults.get(this)(error, results));
        });
    });
  
    }

    
//Use this function if procedures are needed to be executed
    call_procedure(name, args = []) {
        return new Promise((resolve) => {
          _pool
            .get(this)
            .query(`CALL ??(?)`, [name, args], (error, results, fields) => {
              resolve(_getResults.get(this)(error, results));
            });
        });
      }
    






}
module.exports = Database;