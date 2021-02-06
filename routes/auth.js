const express=require("express");
const userController=require("../controllers/user");


const router=express.Router();



router.post('/login',userController.login);

router.get('/logout',userController.logout);



module.exports=router;