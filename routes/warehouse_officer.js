const express=require("express");
const warehouse_officerController=require("../controllers/warehouse_officer");
const router=express.Router();
const authorization = require("../middleware/authorization");

router.get('/add_new_item',authorization.isWarehouseOfficerRole,warehouse_officerController.get_attribute_details);
router.post('/add_new_item',authorization.isWarehouseOfficerRole,warehouse_officerController.add_new_item);
router.get('/update_item_count',authorization.isWarehouseOfficerRole,(req,res)=>{
    res.render('update_item_count',{ message: req.flash('success'), activepage:"update_item_count" });
});
router.post('/update_item_count',authorization.isWarehouseOfficerRole,warehouse_officerController.update_item_count);


router.get('/order',authorization.isWarehouseOfficerRole,warehouse_officerController.get_open_orders);
router.get('/order/:orderId',authorization.isWarehouseOfficerRole,warehouse_officerController.get_order_details);

router.post('/get_order',authorization.isWarehouseOfficerRole,warehouse_officerController.get_order);

router.get('/order_confirm/:orderId',authorization.isWarehouseOfficerRole,warehouse_officerController.confirm_order);


module.exports=router;