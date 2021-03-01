const jwt=require('jsonwebtoken');

const Customer = require("../models/customer");
const customer = new Customer();


exports.get_profile=(req,res)=>{
    const token=req.cookies.jwt;
    
    if(token){
        jwt.verify(token,process.env.JWT_SECRET,async (err,decodedToken)=>{
        
            if(err){
                console.log(error);
                res.render('error',{code:"500",message:"You Need To be Logged in to view profile details"});
                return;
            }
            else if(decodedToken.usertype!='customer'){
                console.log(decodedToken.usertype);
                console.log(error);
                res.render('error',{code:"500",message:"You Need To be a customer to view profile details"});
                return;
            
               
            }else{
                //console.log(decodedToken);
                var email=decodedToken.email;
                const customer_profile = await customer.get_customer_profile(email);
                //console.log(customer_profile);
                if(customer_profile.connectionError==true){
                    console.log("connection error");
                    res.render('error',{code:"500",message:"Server is temporary down"});
                    return;
                }
                else{  
                    let date = JSON.stringify(customer_profile.result[0].dateOfBirth);
                    let bdate = date.slice(1,11);
                    let user_profile={lastname:customer_profile.result[0].lastName,firstname:customer_profile.result[0].firstName, email:customer_profile.result[0].email, address:customer_profile.result[0].address, city:customer_profile.result[0].cityName,birthday:bdate, contactnumber:customer_profile.result[0].contactNumber};
                    res.locals.user_profile=user_profile;
                    res.locals.activepage="profile";
                    res.render('myprofile');
                    return;
                }
                
              
            }
        })
    }else{
        console.log("No Token");
        res.render('error',{code:"500",message:"You Need To be Logged in to view profile details"});
        return;
    }

}


exports.register= async (req,res)=>{
    //console.log("In reg control",req.body);
    
    const {firstname,lastname,email,address,city,birthday,contactnumber,password1,password2}=req.body;
    const user_register_check = await customer.register_check(email);
    //console.log("user_register_check",user_register_check.result);
    if(user_register_check.error==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    if(user_register_check.result.length>0){
        console.log('email already in use');
       // res.locals.details=req.body;
        //res.locals.message='email already in use';
        req.flash("error", "Email Already in use. Please use another email");
        res.redirect("/customer/register")
        return;

    }
    else if(password1!=password2){
        req.flash("error", "Password and the confirmation need to be same.");
        res.redirect("/customer/register")
        return;
    }
    else{
        const user_register_check = await customer.register_insert(firstname,lastname,email,address,city,birthday,contactnumber,password1);
        if(user_register_check.connectionError==true){
            console.log("connection error");
            res.render('error',{code:"500",message:"Server is down."});
            return;
        }
        else if(user_register_check.error==true){
            console.log("Undefined Server Error");
            res.render('error',{code:"500",message:"Server is down."});
            return;
        }
        else{
          
            
            const token=jwt.sign({email:email,usertype:"customer"},process.env.JWT_SECRET,{
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
            return;    
        }       
    } 
}

exports.get_cities=async (req,res)=>{
    const city_details = await customer.get_cities();
    if(city_details.connectionError==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Server is temporary down"});
        return;
    }
    else {
      // res.locals.cities=(city_details.result);       
        res.render('register',{cities:city_details.result});
    }
}











