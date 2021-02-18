//const mysql=require("mysql");
const jwt=require("jsonwebtoken");
const bcrypt=require("bcryptjs");
var multer  = require('multer');
const User = require("../models/user");
const user = new User();
const {Cart,CustomerCart,GuestCart}= require("../models/cart");


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
        for(j=0; j<5; j++){
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

exports.getCartAdditionList= async(req,res)=>{
    //console.log(req.res.locals.useremail);
    if(req.res.locals.useremail){
        var cusCart= new CustomerCart();
        const carAdditiontList= await cusCart.getCartAdditions(req.res.locals.useremail);
        setData(carAdditiontList,cusCart);
    }
    else{
        var gstCart= new GuestCart();
        //console.log(req.res.locals.guest_num);
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
            res.render('mycart',{data:arr,subtotal:subtotal,totalcount:totalcount});
        }
    }
}

exports.RemoveItem= async(itemId,cartId)=>{
    var cart= new Cart();
    const removeItem=await cart.RemoveCartItem(itemId,cartId);
    if(removeItem.connectionError==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Server is temporary down"});
        return;
    }
    else {
       console.log("deleted");
    }
}

exports.changeQuntity= async(itemId,cartId,value)=>{
    var cart= new Cart();
    const itemcount= await cart.getItemCount(itemId,cartId);
    if(itemcount.connectionError==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Server is temporary down"});
        return;
    }
    else {
       var val= itemcount.result[0].count;
       //console.log(value);
       //console.log(val);
       if(value>val){
           const additem= await cart.addCartItem(itemId,cartId);
           if(additem.connectionError==true){
            console.log("connection error");
            res.render('error',{code:"500",message:"Server is temporary down"});
            return;
            }
            else {
                console.log("inserted");
            }
       }
       else{
           const deleteitem =await cart.RemoveCartItem(itemId,cartId);
           if(deleteitem.connectionError==true){
            console.log("connection error");
            res.render('error',{code:"500",message:"Server is temporary down"});
            return;
            }
            else {
                console.log("deleted");
                return;
            }
       }
    }
}














