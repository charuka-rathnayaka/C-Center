const jwt=require('jsonwebtoken');
const WarehouseOfficer = require("../models/warehouse_officer");
const warehouse_officer = new WarehouseOfficer();



exports.get_attribute_details=async (req,res)=>{
    const attribute_details = await warehouse_officer.get_attributes();
    if(attribute_details.connectionError==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Server is temporary down"});
        return;
    }
    else {
        res.locals.attributes=JSON.stringify(attribute_details.result);       
        res.render('add_new_item',{ message: req.flash('success') });
    }
}



exports.add_new_item=async(req,res)=>{
    var req_data=req.body;
    const Item_insert = await warehouse_officer.add_new_item(req_data);
    if(Item_insert.connectionError==true){
        console.log("Connection Error");
        res.render('error',{code:"500",message:"Connection Error.Server is down."});
        return;
        
    }
    else if(Item_insert.error==true){
        console.log("Insert Error");
        res.render('error',{code:"500",message:"Undefined Error Occured.Server is down."});
        return;   
    }
    else {
        console.log("successfully executed");
        req.flash("success", "Item Successfully Added.");
        res.redirect("/warehouse_officer/add_new_item")
        return;   
    }    
 }


 exports.update_item_count=async(req,res)=>{
   // console.log(req.body);
    
    var item_id=req.body.item_id;
    var item_quantity=req.body.quantity;
    const Item_update = await warehouse_officer.update_item_count(item_id,item_quantity);
    if(Item_update.connectionError==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Connection Error.Server is down."});
        return;
        
    }
    else if(Item_update.error==true){
        console.log("Undefined error");
        res.render('error',{code:"500",message:"Undefined Error Occured.Server is down."});
        return;   
    }
    else {
        console.log("successfully executed");
        req.flash("success", "Item Count Successfully Updated.");
        res.redirect("/warehouse_officer/update_item_count")
        return;
          
    }    

 }

 exports.get_open_orders=async(req,res)=>{
    const open_orders = await warehouse_officer.get_open_orders();
    if(open_orders.connectionError==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Server is temporary down"});
        return;
    }
    else {
       
       
        res.locals.open_orders=(open_orders.result);       
        res.status(200).render('orders');
    }
     
   

 }


 exports.get_order_details=async(req,res)=>{
    var orderId = req.params.orderId;
   
    const order_details = await warehouse_officer.get_order_details(orderId);
    if(order_details.connectionError==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Server is temporary down"});
        return;
    }
    else {
       
        res.locals.order_details=(order_details.result); 
        res.locals.cartId=(order_details.result[0]["cartId"]);
        res.locals.orderId=(order_details.result[0]["orderId"]);
        res.locals.delievery=(order_details.result[0]["delieveryMethod"]);    
       
        res.status(200).render('order_details');
    }

   

 }
 