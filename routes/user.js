const express=require("express");
const router=express.Router();
var bodyParser = require('body-parser')
var jsonParser = bodyParser.json();
const userController=require("../controllers/user");


router.get('/',userController.get_home_details);

router.get('/login',(req,res)=>{
    res.render('login');
});

router.get('/mycart',userController.getCartAdditionList);
router.get('/mycart/remove',jsonParser,function(req,res){
    userController.RemoveItem(req.query.id,req.query.cartId);
    res.redirect('/mycart');
});
router.post('/mycart/json',jsonParser,function(req,res){
    userController.changeQuntity(req.body.itemId,req.body.cartId,req.body.value);
    res.redirect('/mycart');
});




module.exports=router;