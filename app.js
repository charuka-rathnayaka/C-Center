const express=require('express');
const path=require("path");
const dotenv=require('dotenv');
const cookieParser=require("cookie-parser");
dotenv.config({path:'./.env'});
const checkuser=require('./middleware/auth_middleware.js');
const app=express();


app.use(express.static('public'));
app.use(express.json());
app.use(cookieParser());

const hbs = require('hbs');
var fs = require('fs');

app.use(cookieParser());
app.use(express.urlencoded({extended:true}));

//refering to public folder
const public_directory = path.join(__dirname,'./public');
app.use(express.static(public_directory));

//setting the template engine as hbs
app.set('view engine','hbs');

//refering to partial folder
hbs.registerPartials(__dirname + '/views/partials');

//registering an if function for hbs pages
hbs.registerHelper('ifeq', function (a, b, options) { 
    if (a == b) { 
        return options.fn(this); }
    else {
        return options.inverse(this);
        }
    //return options.inverse(this);
});


const flash = require('connect-flash');
var session = require('express-session');
app.use(session({secret: '{secret}', name: 'session_id', saveUninitialized: true, resave: true}));
app.use(flash());

// Add errors on locals.
app.use(function (req, res, next) {
  res.locals.errors = req.flash("error");
  next();
});


//Dividing routing according to the user
app.use('*',checkuser);
app.use('/',require("./routes/user"));
app.use("/auth",require("./routes/auth"));
app.use("/admin",require("./routes/admin"));
app.use("/sales_manager",require("./routes/sales_manager"));
app.use("/customer",require("./routes/customer"));
app.use("/warehouse_officer",require("./routes/warehouse_officer"));


//if undefined url is called error page renderd
app.get('/*', (req, res)=>{
    //console.log("page not found");
    res.status(400).render('error',{code:"404",message:"Page Not Found"});
  });


//localhost port selected as 5000
app.listen(5000,()=>{
    console.log('Server started');
})
