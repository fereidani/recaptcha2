(function() {
  var DEFAULT_CONFIG, DEFAULT_REQUEST_OPTIONS, ERRORS, GOOGLE_CAPTCHA_ENDPOINT, Recaptcha2, request;

  request = require('request');

  ERRORS = {
    'request-error': 'Api request failed.',
    'missing-input-secret': 'The secret parameter is missing.',
    'invalid-input-secret': 'The secret parameter is invalid or malformed.',
    'missing-input-response': 'The response parameter is missing.',
    'invalid-input-response': 'The response parameter is invalid or malformed.'
  };

  GOOGLE_CAPTCHA_ENDPOINT = "https://www.google.com/recaptcha/api/siteverify";

  DEFAULT_CONFIG = {
    siteKey: null,
    secretKey: null,
    ssl: true
  };

  DEFAULT_REQUEST_OPTIONS = {
    uri: GOOGLE_CAPTCHA_ENDPOINT,
    method: "POST",
    json: true,
    form: {}
  };

  Recaptcha2 = (function() {
    Recaptcha2.prototype.apiEndpoint = GOOGLE_CAPTCHA_ENDPOINT;

    function Recaptcha2(config) {
      this.config = Object.assign({}, DEFAULT_CONFIG, config);
      if (this.config.ssl === false) {
        this.apiEndpoint = this.apiEndpoint.replace("https", "http");
      }
    }

    Recaptcha2.prototype.getRequestOptions = function(body) {
      body.secret = this.config.secretKey;
      return Object.assign({}, DEFAULT_REQUEST_OPTIONS, {
        uri: this.apiEndpoint,
        form: body
      });
    };

    Recaptcha2.prototype.validate = function(response, remoteip) {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          var options;
          if (!response) {
            return reject(['missing-input-response']);
          }
          options = _this.getRequestOptions({
            response: response,
            remoteip: remoteip
          });
          return request(options, function(error, response, body) {
            if (error) {
              return reject(['request-error', error.toString()]);
            }
            if (body.success === true) {
              return resolve(true);
            }
            return reject(body['error-codes']);
          });
        };
      })(this));
    };

    Recaptcha2.prototype.validateRequest = function(req, ip) {
      return this.validate(req.body['g-recaptcha-response'], ip);
    };

    Recaptcha2.prototype.translateErrors = function(errorCodes) {
      var i, key, len, readableErrors;
      if (!Array.isArray(errorCodes)) {
        return ERRORS[errorCodes] || errorCodes;
      }
      readableErrors = [];
      for (i = 0, len = errorCodes.length; i < len; i++) {
        key = errorCodes[i];
        readableErrors.push(ERRORS[key] || key);
      }
      return readableErrors;
    };

    Recaptcha2.prototype.formElement = function(htmlClass) {
      if (htmlClass == null) {
        htmlClass = 'g-recaptcha';
      }
      return '<div class="' + htmlClass + '" data-sitekey="' + this.config.siteKey + '"></div>';
    };

    return Recaptcha2;

  })();

  module.exports = Recaptcha2;

}).call(this);
