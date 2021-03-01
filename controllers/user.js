//const mysql=require("mysql");
const jwt=require("jsonwebtoken");
const bcrypt=require("bcryptjs");
var multer  = require('multer');
const User = require("../models/user");
const Customer = require("../models/customer");
const Guest = require("../models/guest");
const user = new User();
const {Cart,CustomerCart,GuestCart}= require("../models/cart");
const url = require('url');
const customer = new Customer();
const guest = new Guest();



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
        for (j = 0; j < 6; j++) {
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
    console.log(req.res.locals.usertype);
    console.log(req.res.locals.Id);
    if(req.res.locals.useremail){
        var cusCart= new CustomerCart();
        const carAdditiontList= await cusCart.getCartAdditions(req.res.locals.Id);
        setData(carAdditiontList,cusCart);
    }
    else{
        console.log(req.res.locals.guest_num);
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

exports.getCartHistory= async(req,res)=>{
    var cusCart= new CustomerCart();
    const purchasedCarts = await cusCart.getCartAdditionsHistory(req.res.locals.Id); 
    if(purchasedCarts.connectionError==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    else{
        //console.log(purchasedCarts.result);
        var carts= purchasedCarts.result;
        var lst=[];
        var i;

        for(i=0;i<carts.length;i++){
            var amount=0;
            var cartId= carts[i].cartId;
            var count= carts[i].count;
            var d= carts[i].dateOfPurchase;
            month = '' + (d.getMonth() + 1);
            day = '' + d.getDate();
            year = d.getFullYear();
            if (month.length < 2){ 
                month = '0' + month;
            }
            if (day.length < 2){ 
                day = '0' + day;
            }
            var dd= [year, month, day].join('-');
            const itms= await cusCart.getItemHistory(req.res.locals.Id,cartId);
            if(itms.connectionError==true){
                res.send('error',{code:"500",message:"server is down"});
                return;
            }
            else{
                var itmlist= itms.result;
                var z;
                for(z=0;z<itmlist.length;z++){
                    var itemId=itmlist[z].itemId;
                    var cunt= itmlist[z].count;
                    const itemprice= await cusCart.getPrice(itemId);
                    if(itemprice.connectionError==true){
                        res.send('error',{code:"500",message:"server is down"});
                        return;
                    }
                    else{
                        var price= itemprice.result[0].value;
                        amount=amount+(parseInt(price)*parseInt(cunt));
                    }
                }
            }
            var obj={cartId:cartId,count:count,dateOfPurchase:dd,amount:amount};
            lst.push(obj);
        }
        //console.log(lst);
        res.render('cartHistory',{data:lst});
    }
}
exports.getHistory= async(customerId,cartId)=>{
    var cusCart= new CustomerCart();
    //console.log(email);
    const itm= await cusCart.getItemHistory(customerId,cartId);
    if(itm.connectionError==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    else{
        //console.log(itm.result);
        var data= itm.result;
        var i;
        var lst=[];
        var cart= new Cart();
        for(i=0;i<data.length;i++){
            var productName=data[i].productName;
            var photoLink= data[i].photoLink;
            var count= data[i].count;
            var itemId= data[i].itemId;
            const x= await cart.getPrice(itemId);
            if(itm.connectionError==true){
                console.log(error);
                res.render('error',{code:"500",message:"Server is down."});
                return;
            }
            else{
                var price= x.result[0].value;
                console.log(price);
                var obj={productName:productName,photoLink:photoLink,count:count,price:price};
                lst.push(obj);
            }
        }
        console.log(lst);
        return lst;
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
        const carAdditiontList= await cusCart.getCartAdditions(req.res.locals.Id);
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
                console.log(existance);
                
                if(existance.connectionError==true || existance.error==true){
                    if (existance.error) throw error;
                    console.log(error);
                    res.render('error',{code:"500",message:"Server is down."});
                    return;
                
                }
                else{
                    
                    //If guest doesn't have a open cart, create a cart
                    if (existance.result[0].cartid==null){
                        const creation=await guest.createCart(decodedToken.guest_id);
                        
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
                                
                    }// if guest has a opened cart
                    else{
                        
                        
                        var cartId=existance.result[0].cartid;
                        
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

    
}

exports.get_div_details=async (req,res)=>{
    const divName = req.url.substring(11,);
    const categoriesOfDiv = await user.get_categories(divName);
    if(categoriesOfDiv.connectionError==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    else{
        var i;
        var result_len=categoriesOfDiv.result.length;
        var cats = [];
        for(i=0;i<result_len;i++) {
            var cat={};
            cat.id=categoriesOfDiv.result[i].categoryId;
            cat.name=categoriesOfDiv.result[i].categoryName;
            cats.push(cat);
        }
        let categories = cats;
        var divisionPageResult = {};
        divisionPageResult.thisDivision = req.url.substring(11,)+'s';
        divisionPageResult.categories = categories;        
        //console.log(divisionPageResult);       
        //res.locals.categories=categories;
        res.locals.divisionPageResult=divisionPageResult;
    }


    // const trending_products_result = await user.get_trending_products();
    const division_products_result = await user.get_division_products(divName);
    if(division_products_result.connectionError==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    else{
        var j;
        let div_products = [];
        for(j=0;j<division_products_result.result.length;j++) {
            if(j<=division_products_result.result.length){
                var prod={};
                prod.id=division_products_result.result[j].productId;
                prod.name=division_products_result.result[j].productName;
                prod.desc=division_products_result.result[j].description;
                prod.image=division_products_result.result[j].photoLink;
                div_products.push(prod);
            } 
        }
        res.locals.div_products=div_products;
    }
    res.render('divisions');
}

exports.getSubCategories=async (req,res)=>{
    const subCatsOfCat = await user.get_sub_categories(req.body.id);
    const category_products_result = await user.get_category_products(req.body.id);
    if(subCatsOfCat.connectionError==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }else if(category_products_result.connectionError==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    else{
        var i;
        var result_len=subCatsOfCat.result.length;
        var subCats = [];
        for(i=0;i<result_len;i++) {
            var subCat={};
            subCat.subCatId=subCatsOfCat.result[i].subCategoryId;
            subCat.subCatName=subCatsOfCat.result[i].subCategoryName;
            subCats.push(subCat);
        }
        let subCategories = subCats;
        var j;
        let cat_products = [];
        for(j=0;j<category_products_result.result.length;j++) {
            if(j<=category_products_result.result.length){
                var prod={};
                prod.id=category_products_result.result[j].productId;
                prod.name=category_products_result.result[j].productName;
                prod.desc=category_products_result.result[j].description;
                prod.image=category_products_result.result[j].photoLink;
                cat_products.push(prod);
            }
        }
        resultOfThis={};
        resultOfThis.subCategories=subCategories;
        resultOfThis.cat_products=cat_products;
        res.status(200).send(resultOfThis);
    }
}

exports.getSubCategoryProducts=async (req,res)=>{
    const sub_category_products_result = await user.get_sub_category_products(req.body.id,req.body.catId);
    if(sub_category_products_result.connectionError==true){
        console.log(error);
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    else{
        var j;
        let sub_cat_products = [];
        for(j=0;j<sub_category_products_result.result.length;j++) {
            if(j<=sub_category_products_result.result.length){
                var prod={};
                prod.id=sub_category_products_result.result[j].productId;
                prod.name=sub_category_products_result.result[j].productName;
                prod.desc=sub_category_products_result.result[j].description;
                prod.image=sub_category_products_result.result[j].photoLink;
                sub_cat_products.push(prod);
            }
        }
        resultOfThis2={};
        resultOfThis2.sub_cat_products=sub_cat_products;
        res.status(200).send(resultOfThis2);
    }
}

    
    

