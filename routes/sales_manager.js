const express=require("express");
const salesmanagerController=require("../controllers/sales_manager");
const router=express.Router();
const authorization = require("../middleware/authorization");

router.get('/add_new_product',authorization.isSalesManagerRole,salesmanagerController.get_category_details);
router.post('/add_product',authorization.isSalesManagerRole,salesmanagerController.add_new_product);
router.get('/report',authorization.isSalesManagerRole,(req,res)=>{
    res.locals.activepage="reports";
    res.render('reports');
});

router.get('/report/annual_sales_report',authorization.isSalesManagerRole,(req,res)=>{
    res.locals.activepage="reports";
    res.render('report/annual_sales_report');
});
router.get('/report/product_preference_report',authorization.isSalesManagerRole,(req,res)=>{
    res.locals.activepage="reports";
    res.render('report/product_preference_period_report');
});
router.get('/report/customer_order_report',authorization.isSalesManagerRole,(req,res)=>{
    res.locals.activepage="reports";
    res.render('report/customer_order_report');
});
router.get('/report/trending_product_report',authorization.isSalesManagerRole,(req,res)=>{
    res.locals.activepage="reports";
    res.render('report/trending_products_report');
});
/*router.get('/report/trending_category_report',authorization.isSalesManagerRole,(req,res)=>{
    res.render('report/trending_category_report');
});
*/

router.post('/report/annual_sales_report/:year'
    ,authorization.isSalesManagerRole,
    salesmanagerController.get_annual_quaretly_sales
    );

router.post('/report/most_sale_products'
    ,authorization.isSalesManagerRole,
    salesmanagerController.get_most_saled_products
    );

router.get('/report/trending_category_report'
    ,authorization.isSalesManagerRole,
    salesmanagerController.get_most_saled_categories
    );

router.post('/report/most_prefer_period'
    ,authorization.isSalesManagerRole,
    salesmanagerController.get_most_prefer_period
    );


router.post('/report/customer_order_details'
    ,authorization.isSalesManagerRole,
    salesmanagerController.get_customer_order_report
    );




    
module.exports=router;