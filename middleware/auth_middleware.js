const jwt=require('jsonwebtoken');
const User = require("../models/user");
const userc = new User();

const Guest = require("../models/guest");
const guest = new Guest();

const checkuser=async (req,res,next)=>{
    const token=req.cookies.jwt;
    
    if(token){
        jwt.verify(token,process.env.JWT_SECRET,async (err,decodedToken)=>{
        
            if(err){
                console.log(err.message);
                res.locals.user=null;
                res.locals.Id=null;
                res.locals.usertype=null;
                res.locals.useremail=null;
                res.status(403).render('error',{code:"403",message:"Undefined Error Occured"});
               // res.redirect('/login');
               next();
            }
            
            else{
                const user_type_check = await userc.get_user(decodedToken.email);
               // console.log(user_type_check);
                if(user_type_check.connectionError==true){
                    console.log("connection error");
                    res.render('error',{code:"500",message:"Server is temporary down"});
                    return;
                }
                if(user_type_check.error==true){
                    console.log("Unexpected Error");
                    res.render('error',{code:"500",message:"Server is temporary down"});
                    return;
                }
                else{
                let user=user_type_check.result[0].firstName;
                let useremail=user_type_check.result[0].email;
                let usertype=user_type_check.result[0].role;
                let userId=user_type_check.result[0].Id
                ;
                res.locals.user=user;
                res.locals.usertype=usertype;
                res.locals.useremail=useremail;
                res.locals.Id=userId;
                return next();
                }
            }
        })
    }else{
        
        const guest_token=req.cookies.guest_jwt;

        res.locals.user=null;
        res.locals.usertype=null;
        res.locals.useremail=null;
        res.locals.Id=null;
        if(!guest_token){
            const get_guest_id = await guest.get_guest_id();
            if(get_guest_id .connectionError==true){
                console.log("connection error");
                res.render('error',{code:"500",message:"Server is down."});
                return;
            
                }else{
                   // console.log(get_guest_id.result.insertId);
                   res.locals.usertype="Guest";
                    const id=get_guest_id.result.insertId;
                    const guest_token=jwt.sign({guest_id:id,},process.env.JWT_SECRET,{
                        expiresIn:process.env.JWT_Expires_in
                    });
                    const cookieoption={
                        expires: new Date(
                            Date.now()+process.env.JWT_Cookie_expires *24 *60 *60 * 1000
                        ),
                        httpOnly:true
                    }
                    res.cookie('guest_jwt',guest_token,cookieoption);
                    res.locals.guest_num= id;
                 
                }
            
        }
        else{
            jwt.verify(guest_token,process.env.JWT_SECRET,async (err,decodedToken)=>{
                if(err){
                    console.log(err);
                    res.status(403).render('error',{code:"403",message:"Undefined Error Occured"});
                }else{
                    //console.log(decodedToken);
                    res.locals.usertype="Guest";
                    var id= decodedToken.guest_id;
                    res.locals.guest_num=id;
                    
                }
            })
        }
        next();
    }
}
module.exports =checkuser;