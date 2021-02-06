const express=require("express");
const salesmanagerController=require("../controllers/sales_manager");
const router=express.Router();
const authorization = require("../middleware/authorization");

router.get('/add_new_product',authorization.isSalesManagerRole,salesmanagerController.get_category_details);
router.post('/add_product',authorization.isSalesManagerRole,salesmanagerController.add_new_product);



module.exports=router;