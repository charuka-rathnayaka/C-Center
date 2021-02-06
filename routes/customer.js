const express=require("express");
const customerController=require("../controllers/customer");
const router=express.Router();
const authorization = require("../middleware/authorization");

router.get('/register',customerController.get_cities);

router.post('/auth/register',customerController.register);
router.get('/get_profile',authorization.isCustomerRole,customerController.get_profile);

module.exports=router;