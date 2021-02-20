//const mysql=require("mysql");
const jwt=require("jsonwebtoken");
const bcrypt=require("bcryptjs");
var multer  = require('multer');
const User = require("../models/user");
const Customer = require("../models/customer");
const Guest = require("../models/guest");
const user = new User();
const customer = new Customer();
const guest = new Guest();



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
            var prodValue = {'ID':new_products_result.result[result_len-1].productId,'name':new_products_result.result[result_len-1].productName,'desc':new_products_result.result[result_len-1].description,'image':new_products_result.result[result_len-1].photoLink};
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
   
    res.render('index');

    


}

exports.getDetails=async (req,res)=>{
    
    //get productID from URL
    const product_id=req.params.product_id;
   
    
    // get details of the product
    const productDetails = await user.showInformation(product_id);

    if(productDetails.connectionError==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    try{
        if (productDetails.result.length ===0){
            return res.status(404).send("Error 404");
        }
        
        var array=[];
        var items=[];
        
        
        
            
        for (var i=0;i<productDetails.result.length;i++){

            array.push({ 
                id:productDetails.result[i].itemId,
                key:productDetails.result[i].attributeName,
                value:productDetails.result[i].value
            });

        }
        for (var i = 0; i < array.length; i++) {
            var datum = array[i];
            availability=false;
            for (var j=0; j<items.length;j++){
                if (items[j].includes(datum.id,)) {
                    availability=true;
                    break;
                }
            }
            if (availability==false){
                items.push([datum.id,[],productDetails.result[0].productName,productDetails.result[0].description,productDetails.result[0].photoLink])
            }
            for (var j=0; j < items.length; j++){
                if (items[j][0]==datum.id){
                    items[j][1].push([datum.key,datum.value]);
                }
            }
        
            
            
            
        }
        console.log(items);
        //send data to front end
        return res.status(200).render('items',{
            pageTitle:productDetails.result[0].productName,
            items:items,
        });
    }catch(error){
        console.log(error.message)
        //send 'internal server error'
        res.render('error',{code:"500",message:"Server is down."});
    }
}

exports.getItemDetails=async (req,res)=>{
    
    //get productID from URL
    const item_id=req.params.itemID;

    
    // get details of the item
    const itemDetails = await user.showItemInformation(item_id);

    if(itemDetails.connectionError==true||itemDetails.error==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    try{
        
        if (itemDetails.result.length ===0){
    
            return res.render('error',{code:"404",message:"Item is Not Found"});
        }
        
        var items=[];
        
        for (var i = 0; i < itemDetails.result.length; i++) {
            var datum = itemDetails.result[i];
            if (i==0){
                items.push(datum.itemId,[],datum.productName,datum.description,datum.photoLink);
            }
            
            items[1].push([datum.attributeName,datum.value]);
               
        }

        
        //send data to front end
        return res.status(200).render('addition',{
            items:items,
        });
    }catch(error){
        console.log(error.message);
        //send 'internal server error'
        res.render('error',{code:"500",message:"Server is down."});
    }
}

exports.sentToCart = async(req,res)=>{
    
    
    const token=req.cookies.jwt;
    const guest_token=req.cookies.guest_jwt;
    const quantity=req.body;
    const itemID=req.params.itemID;
    


    
    //check whether that the user is a customer
    if(token){
        jwt.verify(token,process.env.JWT_SECRET,async (err,decodedToken)=>{
            
            if(err){
                console.log(err);
                res.render('error',{code:"500",message:"Server is down!"});
                return;
            }
            
            else if(decodedToken.usertype=='customer'){
                //check whether customer have a cart
                const existance=await customer.checkCart(decodedToken.email);
                

                if(existance.connectionError==true || existance.error==true){
                    console.log(error);
                    res.render('error',{code:"500",message:"Server is down."});
                    return;
                
                }
                else{
                    //If customer doesn't have a open cart, then create a cart
                    if (existance.result.length==0){
                        const creation=await customer.createCart(decodedToken.email);
                        
                        if(creation.connectionError==true || creation.error==true){
                            console.log(error);
                            res.render('error',{code:"500",message:"Server is down."});
                            return;
                        }
                        else{
                            //get created cart id
                            const cartIdInfo=await customer.getCartId(decodedToken.email);
                            var cartId =cartIdInfo.result[0].cartid;
                    
                            if (cartIdInfo.connectionError==true || cartIdInfo.error==true){
                                console.log(error);
                                res.render('error',{code:"500",message:"Server is down."});
                                return;
                            }else{
                                
                                //add to the cartaddition table
                                const addition = await user.addToCart(cartId,quantity.quantity,itemID);
                                
                                if(addition.connectionError==true){
                                    console.log(error);
                                    res.render('error',{code:"500",message:"Server is down."});
                                    return;
                                }
                                res.status(200).redirect('/');
                                return
                            }
                        }
                                
                    }//if customer have a opened cart
                    else{
                        
                        var cartId=existance.result[0].cartid;
                        
                        //add to the cartaddition table
                        const addition = await user.addToCart(cartId,quantity.quantity,itemID);
                        
                        if(addition.connectionError==true){
                            console.log(error);
                            res.render('error',{code:"500",message:"Server is down."});
                            return;
                        }
                        res.status(200).redirect('/');
                        return
                        
                    
                    }
            
                }
    
                             
                         
            }
        })
    }
    else if (guest_token){
        jwt.verify(guest_token,process.env.JWT_SECRET,async (err,decodedToken)=>{
            console.log(decodedToken.guest_id);
            if(err){
                console.log(err);
                res.render('error',{code:"500",message:"Server is down!"});
                return;
            }
            
            else {
                //check whether guest have a cart
                const existance=await guest.checkCart(decodedToken.guest_id);
                console.log("gone");
                console.log(existance);

                if(existance.connectionError==true || existance.error==true){
                    console.log(error);
                    res.render('error',{code:"500",message:"Server is down."});
                    return;
                
                }
                else{
                    //If guest doesn't have a open cart, create a cart
                    if (existance.result[0].cartid==null){
                        const creation=await guest.createCart(decodedToken.guest_id);
                        console.log("creation");
                        console.log(creation);
                        if(creation.connectionError==true || creation.error==true){
                            console.log(error);
                            res.render('error',{code:"500",message:"Server is down."});
                            return;
                        }
                        else{
                            //get the created cartId
                            const cartIdInfo=await guest.getCartId(decodedToken.guest_id);
                            
                    
                            if (cartIdInfo.connectionError==true || cartIdInfo.error==true){
                                console.log(error);
                                res.render('error',{code:"500",message:"Server is down."});
                                return;
                            }else{
                                var cartId =cartIdInfo.result[0].cartid;
                                console.log(quantity.quantity);
                                //add to the cartaddition table
                                const addition = await user.addToCart(cartId,quantity.quantity,itemID);
                                console.log(addition);
                                if(addition.connectionError==true){
                                    console.log(error);
                                    res.render('error',{code:"500",message:"Server is down."});
                                    return;
                                }
                                res.status(200).redirect('/');
                                return
                            }
                        }
                                
                    }// if guest has a opened cart
                    else{
                        
                        console.log(existance.result[0].cartid);
                        var cartId=existance.result[0].cartid;
                        console.log(quantity.quantity);
                        const addition = await user.addToCart(cartId,quantity.quantity,itemID);
                        console.log(addition);
                        if(addition.connectionError==true){
                            console.log(error);
                            res.render('error',{code:"500",message:"Server is down."});
                            return;
                        }
                        res.status(200).redirect('/');
                        return
            
                    }
    
                }             
                         
            }
        })
     }

    
}

    
    

