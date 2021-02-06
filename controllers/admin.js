const jwt=require("jsonwebtoken");
const bcrypt=require("bcryptjs");
const Admin = require("../models/admin");
const admin = new Admin();

exports.add_employee=async (req,res)=>{
   
    const {firstname,lastname,email,recruitment_day,role,birthday,contactnumber,password1,password2}=req.body;
    const employee_register_check = await admin.employee_register_check(email);
   // console.log(employee_register_check);
    if(employee_register_check.error==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    if(employee_register_check.result.length>0){
        console.log('email already in use');
        res.locals.details=req.body;
        res.locals.email_error='email already in use';
        res.render('add_employee');
        return;

    }
    else if(password1!=password2){
        res.locals.details=req.body;
        res.locals.password_error='Passwords need to be the same';
        res.render('add_employee');
        return;
    }
    else{
        const employee_register = await admin.employee_register_insert(firstname,lastname,email,recruitment_day,role,birthday,contactnumber,password1);
        //console.log(employee_register);
        if(employee_register.connectionError==true){
            console.log("connection error");
            res.render('error',{code:"500",message:"Server is down."});
            return;
        }
        else{  
            res.status(300).redirect("/");
            return;
        }
    }   
}