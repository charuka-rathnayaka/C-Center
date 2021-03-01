const jwt=require("jsonwebtoken");
const bcrypt=require("bcryptjs");
const multer=require("multer");
const SalesManager = require("../models/sales_manager");
const salesmanager = new SalesManager();
const path = require('path');



exports.get_category_details=async (req,res)=>{
    const division_category = await salesmanager.get_division_category();
    if(division_category.connectionError==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Server is down."});
        return;
    }
    else{
        res.locals.division_category=JSON.stringify(division_category.result);
        //console.log("division_category",division_category.result);

    }

    const divisions = await salesmanager.get_divisions();
    if(divisions.connectionError==true){
        console.log("Connection error");
        res.render('error',{code:"500",message:"Server is down."});
        return;
        
    }
   
    else {
      
       res.locals.divisions=JSON.stringify(divisions.result);
      // console.log("divisions",divisions.result);
       // res.locals.divisions=divisions;
        
    }

    const category_subcategory = await salesmanager.get_category_subcategory();
    if(category_subcategory.connectionError==true){
        console.log("Connection Error");
        res.render('error',{code:"500",message:"Server is down."});
        return;
        
    }
   
    else {
     

        res.locals.category_subcategory=JSON.stringify(category_subcategory.result);
      
        
    }
    res.locals.message=req.flash('success');
    res.locals.activepage="add_new_product";
    res.render('add_new_product');
   
}



exports.add_new_product=async(req,res)=>{
 
var stored_image;
 
  upload (req, res, async(err) => {
  
    if(err){
        console.log("error in upload");
        res.render('error',{code:"500",message:"Unexpected Error in uploading Product Image"});
        return;
    } else {
      if(req.file == undefined){
        console.log("No File");
        res.render('error',{code:"500",message:"No Product Image Selected"});
                return;
      } else {
          console.log("file uploaded");
         
          stored_image =req.file.filename;
            const Product_insert = await salesmanager.add_new_product(req.body,stored_image);
            if(Product_insert.connectionError==true){
                console.log("connection ërror occured");
                res.render('error',{code:"500",message:"Connection Error.Server is down."});
                return;
                
            }
            else if(Product_insert.error==true){
                console.log("Insert error occured");
                res.render('error',{code:"500",message:"Undefined Error Occured.Server is down."});
                return;   
            }
            else {
                console.log("successfully executed");
                req.flash("success", "Product Successfully Added.");
              res.redirect("/sales_manager/add_new_product")
              return;     
            }
      }
    }
  });
 
  
   
}
const storage = multer.diskStorage({
    destination: './public/product_images/',
    filename: function(req, file, cb){
      cb(null,file.fieldname + '-' + Date.now() + path.extname(file.originalname));
    }
  });
  
  // Init Upload
  const upload = multer({
    storage: storage,
    limits:{fileSize: 1000000},
    fileFilter: function(req, file, cb){
      checkFileType(file, cb);
    }
  }).single('product_image');
  
  // Check File Type
  function checkFileType(file, cb){
    // Allowed ext
    const filetypes = /jpeg|jpg|png|gif/;
    // Check ext
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    // Check mime
    const mimetype = filetypes.test(file.mimetype);
  
    if(mimetype && extname){
      return cb(null,true);
    } else {
      cb('Error: Images Only!');
    }
  }


  exports.get_annual_quaretly_sales=async (req,res)=>{
    var year = req.params.year;
    const anuual_quaretly_details = await salesmanager.get_annual_sales(year);
    if(anuual_quaretly_details.connectionError==true){
        console.log("connection error");
        res.render('error',{code:"500",message:"Server is temporary down"});
        return;
    }
    else {
       res.status(200).send(anuual_quaretly_details.result);
    }
}


exports.get_most_saled_products=async (req,res)=>{
  var startdate= req.body.startdate;
  var enddate= req.body.enddate;
  
  const most_saled_products = await salesmanager.get_most_saled_products(startdate,enddate);
  
  if(most_saled_products.connectionError==true){
      console.log("connection error");
      res.render('error',{code:"500",message:"Server is temporary down"});
      return;
  }
  else {
     res.status(200).send(most_saled_products.result);
  }
}

exports.get_most_saled_categories=async (req,res)=>{
  const most_saled_categories = await salesmanager.get_most_saled_categories();
  
  if(most_saled_categories.connectionError==true){
      console.log("connection error");
      res.render('error',{code:"500",message:"Server is temporary down"});
      return;
  }
  else {
    res.locals.top_categories=most_saled_categories.result;
    res.locals.activepage="reports";
     res.status(200).render('report/trending_category_report');
  }
}

exports.get_most_prefer_period=async (req,res)=>{
  var product_id= req.body.product_id;
  const most_prefer_period_product = await salesmanager.get_most_prefer_period(product_id);
  
  if(most_prefer_period_product.connectionError==true){
      console.log("connection error");
      res.render('error',{code:"500",message:"Server is temporary down"});
      return;
  }
  else {
    res.status(200).send(most_prefer_period_product.result);
  }
}


exports.get_customer_order_report=async (req,res)=>{
  var email= req.body.customer_email;
  const customer_order = await salesmanager.get_customer_order(email);
  
  if(customer_order.connectionError==true){
      console.log("connection error");
      res.render('error',{code:"500",message:"Server is temporary down"});
      return;
  }
  else {
    res.status(200).send(customer_order.result);
  }
}