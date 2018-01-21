# reCAPTCHA2
Easy verifier for Google reCAPTCHA version 2 for Node.js

# Documents :

**First:**

You need to receive your site key and secret key for your domain from https://www.google.com/recaptcha/intro/

Follow the steps on this page to include the reCAPTCHA on your website.

**How to initialize:**
```js
var reCAPTCHA = require('recaptcha2');

var recaptcha = new reCAPTCHA({
  siteKey: 'your-site-key',
  secretKey: 'your-secret-key'
});
```
**Configuration details:**

Config of main class is a javascript object and attributes are :

```
siteKey: your Site Key from Google
secretKey: your Secret Key from Google
ssl: use https to access Google API ( boolean - default = true )
```

**How to verify the reCAPTCHA response:**

reCAPTCHA2 use Promises to validate the reCAPTCHA, you can easily use following methods to verify the responses:
* please mention on catch , library passes error codes from google which you can translate with translateErrors method

Simple:
```js
recaptcha.validate(key)
  .then(function(){
    // validated and secure
  })
  .catch(function(errorCodes){
    // invalid
    console.log(recaptcha.translateErrors(errorCodes)); // translate error codes to human readable text
  });
```
**Optional:** You can also pass the clients IP address to the validate method after the key. For more information on that, please see the [reCAPTCHA documentation](https://developers.google.com/recaptcha/docs/verify).

For Express (you need body-parser):
```js
function submitForm(req, res) {
  recaptcha.validateRequest(req)
    .then(function(){
      // validated and secure
      res.json({formSubmit:true})
    })
    .catch(function(errorCodes){
      // invalid
      res.json({
        formSubmit: false,
        errors: recaptcha.translateErrors(errorCodes) // translate error codes to human readable text
      });
    });
}
```

**Form Element:**

recaptcha.formElement() returns standard form element for reCAPTCHA which you should include in end of your html form element

you can also set class name like recaptcha.formElement('custom-class-for-recaptcha')

# Changelog

Please see the [CHANGELOG.md](https://github.com/fereidani/recaptcha2/blob/master/CHANGELOG.md).
