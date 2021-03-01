const express=require("express");
const adminController=require("../controllers/admin");
const router=express.Router();
const authorization = require("../middleware/authorization");


router.get('/add_employee',authorization.isAdminRole,(req,res)=>{ 
    res.render('add_employee',{ success: req.flash('success'),errormsg:req.flash('errormsg'),activepage:"add_employee" });
});

router.post('/add_employee',authorization.isAdminRole,adminController.add_employee);
module.exports=router;