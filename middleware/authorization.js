const jwt=require('jsonwebtoken');

exports.isCustomerRole = (req, res, next) => {
    if (req.res.locals.usertype == "customer") {
      next();
    } else {
        res.render('error',{code:"403",message:"Forbidden Client"});
    }
  };

exports.isAdminRole = (req, res, next) => {
    if (req.res.locals.usertype == "admin") {
      next();
    } else {
        res.status(403).render('error',{code:"403",message:"Forbidden Client"});
    }
  };

  exports.isSalesManagerRole = (req, res, next) => {
    if (req.res.locals.usertype == "Sales manager") {
      next();
    } else {
        res.status(403).render('error',{code:"403",message:"Forbidden Client"});
    }
  };

  exports.isWarehouseOfficerRole = (req, res, next) => {
    if (req.res.locals.usertype == "Warehouse officer") {
      next();
    } else {
        res.status(403).render('error',{code:"403",message:"Forbidden Client"});
    }
  };

  exports.isGuestOrCustomerRole = (req, res, next) => {
    if ((req.res.locals.usertype == "customer")||(req.res.locals.usertype == "Guest")) {
      next();
    } else {
        res.render('error',{code:"403",message:"Forbidden Client"});
    }
  };