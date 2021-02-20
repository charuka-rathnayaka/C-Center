const express=require("express");
const router=express.Router();

const userController=require("../controllers/user");


router.get('/',userController.get_home_details);





router.get('/login',(req,res)=>{
    res.render('login');
});
router.get('/mycart',(req,res)=>{
    res.render('mycart');
});
router.get('/info/:product_id',userController.getDetails);

router.post('/cart/:itemID',userController.sentToCart);

router.get('/addition/:itemID',userController.getItemDetails)


module.exports=router;