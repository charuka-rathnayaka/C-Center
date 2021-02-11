const express=require("express");
const router=express.Router();

const userController=require("../controllers/user");


router.get('/',userController.get_home_details);





router.get('/login',(req,res)=>{
    res.render('login');
});
router.get('/mycart',
    (req,res)=>{
    res.locals.activepage="mycart";
    res.render('mycart');
});



module.exports=router;