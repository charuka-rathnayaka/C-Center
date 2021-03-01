const express=require("express");
const router=express.Router();
var bodyParser = require('body-parser')
var jsonParser = bodyParser.json();
const userController=require("../controllers/user");


router.get('/',userController.get_home_details);

router.get('/login',(req,res)=>{
    res.render('login');
});

router.get('/divisions/Electronic',userController.get_div_details);
router.get('/divisions/Toy',userController.get_div_details);
router.post('/user/subCategories',userController.getSubCategories);
router.post('/user/subCategoryProd',userController.getSubCategoryProducts);
router.get('/info/:product_id',userController.getDetails);

router.post('/cart/:itemID',userController.sentToCart);

router.get('/addition/:itemID',userController.getItemDetails)


router.get('/mycart',userController.getCartAdditionList);
router.post('/mycart/remove', jsonParser, async function (req, res, next) {
    console.log(req.body.itemId,req.body.cartId);
    await userController.RemoveItem(req.body.itemId,req.body.cartId);
    next();
},userController.getCartAdditionListjson);

router.get('/carthistory',userController.getCartHistory);

router.post('/mycart/js',jsonParser,async(req,res,next)=>{
    var x= await userController.getHistory(req.res.locals.Id,req.body.cartId);
    res.json(x);
});

router.post('/mycart/json',jsonParser, async function (req, res, next) {
     
    await userController.changeQuntity(req.body.itemId, req.body.cartId, req.body.value);
    next();
   // res.redirect('/mycart');
},userController.getCartAdditionListjson);

router.get('/order',userController.getCartAdditionList);
router.get('/order/delieveryorder',userController.getCartAdditionList);
router.get('/order/pickuporder', userController.getCartAdditionList);

router.get('/order/delieveryorder/remove',jsonParser,async function (req, res, next) {
    console.log(req.body.itemId,req.body.cartId);
    await userController.RemoveItem(req.body.itemId,req.body.cartId);
    next();
},userController.getCartAdditionListjson);
router.get('/order/pickuporder/remove',jsonParser,async function (req, res, next) {
    console.log(req.body.itemId,req.body.cartId);
    await userController.RemoveItem(req.body.itemId,req.body.cartId);
    next();
},userController.getCartAdditionListjson);

router.post('/order',userController.gettype);
router.post('/order/delieveryorder', userController.delieveryorder);
router.post('/order/pickuporder', userController.pickupOrder);

router.post('/order/pickuporder/json',jsonParser,async function (req, res, next) {
     
    await userController.changeQuntity(req.body.itemId, req.body.cartId, req.body.value);
    next();
   // res.redirect('/mycart');
}, userController.getCartAdditionListjson);

router.post('/order/delieveryorder/json', jsonParser, async function (req, res, next) {
     
    await userController.changeQuntity(req.body.itemId, req.body.cartId, req.body.value);
    next();
   // res.redirect('/mycart');
},userController.getCartAdditionListjson);

module.exports=router;
