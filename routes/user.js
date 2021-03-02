const express=require("express");
const router=express.Router();
var bodyParser = require('body-parser')
var jsonParser = bodyParser.json();
const userController=require("../controllers/user");
const authorization = require("../middleware/authorization");

router.get('/',userController.get_home_details);

router.get('/login',(req,res)=>{
    res.render('login');
});

router.get('/divisions/Electronic',authorization.isGuestOrCustomerRole,userController.get_div_details);
router.get('/divisions/Toy',authorization.isGuestOrCustomerRole,userController.get_div_details);
router.post('/user/subCategories',authorization.isGuestOrCustomerRole,userController.getSubCategories);
router.post('/user/subCategoryProd',authorization.isGuestOrCustomerRole,userController.getSubCategoryProducts);
router.get('/info/:product_id',authorization.isGuestOrCustomerRole,userController.getDetails);

router.post('/cart/:itemID',authorization.isGuestOrCustomerRole,userController.sentToCart);

router.get('/addition/:itemID',authorization.isGuestOrCustomerRole,userController.getItemDetails)


router.get('/mycart',authorization.isGuestOrCustomerRole,userController.getCartAdditionList);
router.post('/mycart/remove',authorization.isGuestOrCustomerRole, jsonParser, async function (req, res, next) {
    await userController.RemoveItem(req.body.itemId,req.body.cartId);
    next();
},userController.getCartAdditionListjson);

router.get('/carthistory',authorization.isCustomerRole,userController.getCartHistory);

router.post('/mycart/js',authorization.isCustomerRole,jsonParser,async(req,res,next)=>{
    var x= await userController.getHistory(req.res.locals.Id,req.body.cartId);
    res.json(x);
});

router.post('/mycart/json',authorization.isGuestOrCustomerRole,authorization.isGuestOrCustomerRole,jsonParser, async function (req, res, next) {
     
    await userController.changeQuntity(req.body.itemId, req.body.cartId, req.body.value);
    next();
   // res.redirect('/mycart');
},userController.getCartAdditionListjson);

router.get('/order',authorization.isGuestOrCustomerRole,userController.getCartAdditionList);
router.get('/order/delieveryorder',authorization.isGuestOrCustomerRole,userController.getCartAdditionList);
router.get('/order/pickuporder',authorization.isGuestOrCustomerRole, userController.getCartAdditionList);

router.get('/order/delieveryorder/remove',authorization.isGuestOrCustomerRole,jsonParser,async function (req, res, next) {
    //console.log(req.body.itemId,req.body.cartId);
    await userController.RemoveItem(req.body.itemId,req.body.cartId);
    next();
},userController.getCartAdditionListjson);
router.get('/order/pickuporder/remove',authorization.isGuestOrCustomerRole,jsonParser,async function (req, res, next) {
   // console.log(req.body.itemId,req.body.cartId);
    await userController.RemoveItem(req.body.itemId,req.body.cartId);
    next();
},userController.getCartAdditionListjson);

router.post('/order',authorization.isGuestOrCustomerRole,userController.gettype);
router.post('/order/delieveryorder',authorization.isGuestOrCustomerRole, userController.send_email_confirmation,userController.delieveryorder);
router.post('/order/pickuporder',authorization.isGuestOrCustomerRole, userController.send_email_confirmation, userController.pickupOrder);

router.post('/order/pickuporder/json',authorization.isGuestOrCustomerRole,jsonParser,async function (req, res, next) {
     
    await userController.changeQuntity(req.body.itemId, req.body.cartId, req.body.value);
    next();
   // res.redirect('/mycart');
}, userController.getCartAdditionListjson);

router.post('/order/delieveryorder/json',authorization.isGuestOrCustomerRole, jsonParser, async function (req, res, next) {
     
    await userController.changeQuntity(req.body.itemId, req.body.cartId, req.body.value);
    next();
   // res.redirect('/mycart');
},userController.getCartAdditionListjson);

module.exports=router;
