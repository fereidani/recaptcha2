# reCAPTCHA2
Easy verifier for google reCAPTCHA version 2 for Node.js

# Documents :

**First:**

You need to recieve Site Key and Secret Key for your domain from : https://www.google.com/recaptcha/intro/index.html

**How to init :**
```
reCAPTCHA=require('recaptcha2')

recaptcha=new reCAPTCHA({
  siteKey:'your-site-key'
  secretKey:'your-secret-key'
})
```
**Config details :**

Config of main class is an javascript object and attributes are :

```
siteKey : your Site Key from google

secretKey : your Secret Key from google

ssl : use https to access google api ( boolean - default : true )
```

**How to verify captcha key :**

reCAPTCHA2 use Promises to validate key you can easily use following methods to verify captchas :
* please mention on catch response library return error codes from google which you can translate with translateErrors method

Simple:
```
recaptcha.validate(key)
.then(function(){
  // validated and secure
})
.catch(function(errorCodes){
  // invalid
  console.log(recaptcha.translateErrors(errorCodes));// translate error codes to human readable text
});
```

For Express (you need body-parser) :
```
function submitForm(req,res){
  recaptcha.validateRequest(req)
  .then(function(){
    // validated and secure
    res.json({formSubmit:true})
  })
  .catch(function(errorCodes){
    // invalid
    res.json({formSubmit:false,errors:recaptcha.translateErrors(errorCodes)});// translate error codes to human readable text
  });
}
```



