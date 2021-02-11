//const mysql=require("mysql");
const jwt=require("jsonwebtoken");
const bcrypt=require("bcryptjs");
var multer  = require('multer');
const User = require("../models/user");
const user = new User();



exports.login=async (req,res)=>{  
        const email=req.body.email;
        const password=req.body.password;
        const user_login = await user.login(req.body.email);
        if(!email || !password){
            return res.status(400).render('login',{
                message:"Please provide and email and password"
            });
        } 
        if(user_login.error==true){
            console.log("connection error");
            res.render('error',{code:"500",message:"Server is down."});
            return;
        }
        else if(user_login.result.length==0){
            res.status(401).render('login',{
                message:"No such registered email"
            })
        }
        else if(!(await bcrypt.compare(password,user_login.result[0]["password"]))){
       
            res.status(401).render('login',{
                message:"Email or password Incorrect"
            })
        }
        else{
            const token=jwt.sign({email:email,usertype:user_login.result[0]["role"]},process.env.JWT_SECRET,{
                expiresIn:process.env.JWT_Expires_in
            });
           
            const cookieoption={
                expires: new Date(
                    Date.now()+process.env.JWT_Cookie_expires *24 * 60 * 60 * 1000
                ),
                httpOnly:true
            }
            res.cookie('jwt',token,cookieoption);
            res.status(300).redirect("/");
    } 
}




exports.logout=(req,res)=>{
    res.cookie("jwt",'',{maxAge:1});
    res.redirect('/');
}


exports.get_home_details=async (req,res)=>{
    //console.log(req.res.locals.usertype);
    const new_products_result = await user.get_new_products();
    //console.log(new_products_result.result);
    if(new_products_result.connectionError==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    else{
        var i;
        var result_len=new_products_result.result.length;
        let new_products={"new_products":{}};
        for(i=0; i<6; i++){
            if(i<=new_products_result.result.length){
            var newprod = "product" + i;
            var prodValue = {'ID':new_products_result.result[result_len-1].ProductId,'name':new_products_result.result[result_len-1].productName,'desc':new_products_result.result[result_len-1].description,'image':new_products_result.result[result_len-1].photoLink};
            result_len=result_len-1;
            new_products.new_products[newprod] = await prodValue ;
        }   }                   
        res.locals.new_products=new_products;
    }


    const trending_products_result = await user.get_trending_products();
    //console.log("lengtth",trending_products_result.result);
    if(trending_products_result.connectionError==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    else{
        var j;
                    
        let trend_products={"trend_products":{}};
        for(j=0; j<6; j++){
            if(j<=trending_products_result.result.length){
            var trendprod = "product" + j;
            var prodValue = {'ID':trending_products_result.result[j].productId,'name':trending_products_result.result[j].productName,'desc':trending_products_result.result[j].description,'image':trending_products_result.result[j].photoLink};                        
            trend_products.trend_products[trendprod] = prodValue ;
            }  }
            res.locals.trend_products=trend_products;
           // console.log("lengtth",trend_products);
                    
    }
    res.locals.activepage="home";
    res.render('index');

    


}














