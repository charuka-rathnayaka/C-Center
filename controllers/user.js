//const mysql=require("mysql");
const jwt=require("jsonwebtoken");
const bcrypt=require("bcryptjs");
var multer  = require('multer');
const User = require("../models/user");
const user = new User();
const {Cart,CustomerCart,GuestCart}= require("../models/cart");
const url = require('url');
const Customer = require("../models/customer");
const customer = new Customer();
exports.login=async (req,res)=>{  
        const email=req.body.email;
        const password=req.body.password;
        const user_login = await user.login(req.body.email);
        if(!email || !password){
            req.flash("error", "Please provide email and password");
            res.redirect("/login");
            return;
        } 
        if(user_login.error==true){
            console.log("connection error");
            res.render('error',{code:"500",message:"Server is down."});
            return;
        }
        else if(user_login.result.length==0){
            req.flash("error", "No Such Email is Registered");
            res.redirect("/login");
            return;
        }
        else if(!(await bcrypt.compare(password,user_login.result[0]["password"]))){
            //res.redirect('/login?error=' + encodeURIComponent('Incorrect_Credential'));
            req.flash("error", "Email or Password is Incorrect");
            res.redirect("/login");
            return;
            
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


exports.get_home_details=async (req,res,next)=>{
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
        for (j = 0; j < 5; j++) {
            if (trending_products_result.result[j]) {
                if (j <= trending_products_result.result.length) {
                    var trendprod = "product" + j;
                    var prodValue = { 'ID': trending_products_result.result[j].productId, 'name': trending_products_result.result[j].productName, 'desc': trending_products_result.result[j].description, 'image': trending_products_result.result[j].photoLink };
                    trend_products.trend_products[trendprod] = prodValue;
                }
            }
            res.locals.trend_products = trend_products;
        }
           // console.log("lengtth",trend_products);
                    
    }
    res.locals.activepage="home";
    res.render('index');

    


}

exports.getCartAdditionList= async(req,res)=>{
    console.log(req.res.locals.useremail);
    if(req.res.locals.useremail){
        var cusCart= new CustomerCart();
        const carAdditiontList= await cusCart.getCartAdditions(req.res.locals.useremail);
        setData(carAdditiontList,cusCart);
    }
    else{
        var gstCart= new GuestCart();
        console.log(req.res.locals.guest_num);
        const carAdditiontList= await gstCart.getCartAdditions(req.res.locals.guest_num);
        setData(carAdditiontList,gstCart);
    }
    async function setData(carAdditiontList,cusCart){
        if(carAdditiontList.connectionError==true){
            console.log("connection error list");
            res.render('error',{code:"500",message:"Server is temporary down"});
            return;
        }
        else{
            console.log(carAdditiontList.result);
            var itemList= carAdditiontList.result;
            var x=0;
            var subtotal=0;
            var arr=[];
            var totalcount=0;
            while(x<itemList.length){    
                const propList= await cusCart.getItemDetail(itemList[x].itemId);
                if(propList.connectionError==true){
                    console.log("connection error list");
                    res.render('error',{code:"500",message:"Server is temporary down"});
                    return;
                }
                else{
                    var prop=propList.result;
                    var count= itemList[x].count;
                    var cartId=itemList[x].cartId;
                    totalcount+=count;
                    var photoLink= itemList[x].photoLink;
                    var productName= itemList[x].productName;
                    itemId= propList.result[0].itemId;
                    var price;
                    var attribute=[];
                    var value=[];
                    var y=0;
                    var prop= propList.result;
                    while(y<prop.length){
                        if(prop[y].attributeName=='Price'){
                            price=prop[y].value;
                            subtotal+=parseInt(price)*count;
                        }
                        else{
                            attribute.push(prop[y].attributeName);
                            value.push(prop[y].value);
                        }
                        y++;
                    }
                    var obj={itemId:itemId,price:price,attribute:attribute,value:value,count:count,photoLink:photoLink,productName:productName,cartId:cartId};
                    arr.push(obj);
                }
                x++;
            }
            
            if (req.url == "/order") {
                res.render('order', { data: arr, subtotal: subtotal, totalcount: totalcount });
            }
            else if (req.url == "/order/delieveryorder") {
                 res.locals= { data: arr, subtotal: subtotal, totalcount: totalcount };
                autofillDelievery(req,res);
            }
            else if (req.url == "/order/pickuporder") { 
                res.locals= { data: arr, subtotal: subtotal, totalcount: totalcount };
                autofillPickup(req,res);
            }
            else {
                 res.render('mycart', { data: arr, subtotal: subtotal, totalcount: totalcount });
               
            }
          
        }
    }
}

exports.RemoveItem= async(itemId,cartId)=>{
    var cart = new Cart();
    console.log(itemId, cartId);
    const val = await cart.UpdateItemCount(itemId, cartId, 0);
    if (val.connectionError == true) {
        console.log("connection error");
        res.render('error', { code: "500", message: "Server is temporary down" });
        return;
    }
    else {
              
        console.log("inserted");
    }

}

exports.changeQuntity = async (itemId, cartId, value) => {
    var cart = new Cart();
    console.log(itemId, cartId, value);
    const val = await cart.UpdateItemCount(itemId, cartId, value);
    if (val.connectionError == true) {
        console.log("connection error");
        res.render('error', { code: "500", message: "Server is temporary down" });
        return;
    }
    else {
              
        console.log("inserted");
    }

}


exports.gettype =async (req, res) => {
    let delieveryMethod = req.body.delieveryMethod;
    console.log(delieveryMethod);
    if (delieveryMethod == "Pickup") {
       
       
          res.redirect('/order/pickuporder');

    }
    else if (delieveryMethod == "Delievery") {
         res.redirect('/order/delieveryorder');
    }
    else { 
        res.render('order');

    }
}
autofillPickup=async (req, res) => { 
     const token=req.cookies.jwt;
    
    if(token){
        jwt.verify(token,process.env.JWT_SECRET,async (err,decodedToken)=>{
        
            if(err){
               console.log(error);
               res.locals.user_profile=null;
               res.render('pickuporder');
                return;
            }
            else if(decodedToken.usertype!='customer'){
               console.log(error);
                res.locals.user_profile=null;
                res.render('pickuporder');
                return;
            
               
            }else{
                //console.log(decodedToken);
                var email=decodedToken.email;
                const customer_profile = await customer.get_customer_profile(email);
                //console.log(customer_profile);
                if(customer_profile.connectionError==true){
                   res.locals.user_profile=null;
                    res.render('pickuporder');
                    return;
                }
                else{  
                    let date = JSON.stringify(customer_profile.result[0].dateOfBirth);
                    let bdate = date.slice(1,11);
                    let user_profile={contactname:customer_profile.result[0].lastName,firstname:customer_profile.result[0].firstName, email:customer_profile.result[0].email, address:customer_profile.result[0].address, city:customer_profile.result[0].city,birthday:bdate, contactnumber:customer_profile.result[0].contactNumber};
                    res.locals.user_profile=user_profile;
                    res.render('pickuporder');
                    
                    return;
                }
                
              
            }
        })
    }else{
       res.locals.user_profile=null;
       res.render('pickuporder');
        return;
    }
    
}

autofillDelievery=async (req, res) => { 
       const token=req.cookies.jwt;
    
    if(token){
        jwt.verify(token,process.env.JWT_SECRET,async (err,decodedToken)=>{
        
            if(err){
               console.log(error);
               res.locals.user_profile=null;
                res.render('delieveryorder');
                return;
            }
            else if(decodedToken.usertype!='customer'){
               console.log(error);
                res.locals.user_profile=null;
                 res.render('delieveryorder');
                return;
            
               
            }else{
                //console.log(decodedToken);
                var email=decodedToken.email;
                const customer_profile = await customer.get_customer_profile(email);
                //console.log(customer_profile);
                if(customer_profile.connectionError==true){
                   res.locals.user_profile=null;
                    res.render('delieveryorder');
                    return;
                }
                else{  
                    let date = JSON.stringify(customer_profile.result[0].dateOfBirth);
                    let bdate = date.slice(1,11);
                    let user_profile={contactname:customer_profile.result[0].lastName,firstname:customer_profile.result[0].firstName, email:customer_profile.result[0].email, address:customer_profile.result[0].address, city:customer_profile.result[0].city,birthday:bdate, contactnumber:customer_profile.result[0].contactNumber};
                    res.locals.user_profile=user_profile;
                     res.render('delieveryorder');
                    
                    return;
                }
                
              
            }
        })
    }else{
       res.locals.user_profile=null;
       res.render('delieveryorder');
        return;
    }
}

exports.pickupOrder =async (req, res) => { 
    const { ContactName, contactnumber, pickupdate, payment } = req.body;
    const order = await user.orderIteams(ContactName, contactnumber, pickupdate, payment, 1);
    if (order.connectionError == true) {
        console.log(error);
        res.render('error', { code: "500", message: "Server is down." });
        return;
    }
    else {
        console.log(order);
         res.redirect("/mycart");
    }
     
}
exports.delieveryorder= (req, res) => { 
    console.log(req.body);
       res.redirect("/mycart");
}


exports.getCartAdditionListjson= async(req,res)=>{
    var cart = new Cart();
    if(req.res.locals.useremail){
        var cusCart= new CustomerCart();
        const carAdditiontList= await cusCart.getCartAdditions(req.res.locals.useremail);
        setData(carAdditiontList,cusCart);
    }
    else{
        var gstCart= new GuestCart();
        console.log(req.res.locals.guest_num);
        const carAdditiontList= await gstCart.getCartAdditions(req.res.locals.guest_num);
        setData(carAdditiontList,gstCart);
    }
    async function setData(carAdditiontList,cusCart){
        if(carAdditiontList.connectionError==true){
            console.log("connection error list");
            res.render('error',{code:"500",message:"Server is temporary down"});
            return;
        }
        else{
            //console.log(carAdditiontList);
            var itemList= carAdditiontList.result;
            var x=0;
            var subtotal=0;
            var arr=[];
            var totalcount=0;
            while(x<itemList.length){    
                const propList= await cusCart.getItemDetail(itemList[x].itemId);
                if(propList.connectionError==true){
                    console.log("connection error list");
                    res.render('error',{code:"500",message:"Server is temporary down"});
                    return;
                }
                else{
                    var prop=propList.result;
                    var count= itemList[x].count;
                    var cartId=itemList[x].cartId;
                    totalcount+=count;
                    var photoLink= itemList[x].photoLink;
                    var productName= itemList[x].productName;
                    itemId= propList.result[0].itemId;
                    var price;
                    var attribute=[];
                    var value=[];
                    var y=0;
                    var prop= propList.result;
                    while(y<prop.length){
                        if(prop[y].attributeName=='Price'){
                            price=prop[y].value;
                            subtotal+=parseInt(price)*count;
                        }
                        else{
                            attribute.push(prop[y].attributeName);
                            value.push(prop[y].value);
                        }
                        y++;
                    }
                    var obj={itemId:itemId,price:price,attribute:attribute,value:value,count:count,photoLink:photoLink,productName:productName,cartId:cartId};
                    arr.push(obj);
                }
                x++;
            }
           const itemcount = await cart.getItemCount(req.body.itemId, req.body.cartId);
            var val= itemcount.result[0].count;
            if (val == 0) {
                res.status(200).send({ data: arr, subtotal: subtotal, totalcount: totalcount ,itemId:req.body.itemId });
            }
            else { 
                res.status(200).send({ data: arr, subtotal: subtotal, totalcount: totalcount });
            }
            
           
          
        }
    }
}











