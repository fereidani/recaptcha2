nock      = require "nock"
should    = require "should"
Recaptcha2 = require "../index.coffee"

recaptcha2 = new Recaptcha2 siteKey: "public_site_key", secretKey: "secret_key"

GOOGLE_CAPTCHA_ENDPOINT = "https://www.google.com/recaptcha/api/siteverify"

describe "recaptcha2", ->
  
  it "has a default config", ->
    recaptcha2.config.should.eql siteKey: "public_site_key", secretKey: "secret_key", ssl: true
  
  it "has a default secure endpoint", ->
    recaptcha2.apiEndpoint.should.eql GOOGLE_CAPTCHA_ENDPOINT
  
  it "has an unsecure endpoint when ssl disabled", ->
    unsecureRecaptcha2 = new Recaptcha2 siteKey: "public_site_key", secretKey: "secret_key", ssl: false
    unsecureRecaptcha2.apiEndpoint.should.eql GOOGLE_CAPTCHA_ENDPOINT.replace("https", "http")

  describe "getRequestOptions", ->
    body = response: "g-recaptcha_frontend_response", remoteip: "origin_ip"
    
    it "returns the request options with the given form body", ->
      recaptcha2.getRequestOptions(body).should.eql
        uri: GOOGLE_CAPTCHA_ENDPOINT
        method: "POST"
        json: true
        form: body

  describe "translateErrors", ->
    describe "when the given error is a string", ->  
      
      it "returns a verbose string error", ->
        recaptcha2.translateErrors("request-error").should.eql "Api request failed."
    
    describe "when the given error is an array", ->
      
      it "returns a verbose errors array", ->
        errors = [
          'missing-input-secret', 'invalid-input-secret',
          'missing-input-response', 'invalid-input-response'
        ]
        readableErrors = [
          'The secret parameter is missing.'
          'The secret parameter is invalid or malformed.'
          'The response parameter is missing.'
          'The response parameter is invalid or malformed.'
        ]
        recaptcha2.translateErrors(errors).should.eql readableErrors

  describe "formElement", ->
    describe "when there is a given htlm class", ->
      
      it "returns a div with the given class", ->
        div = '<div class="test-class" data-sitekey="public_site_key"></div>'
        recaptcha2.formElement("test-class").should.eql div

    describe "when there is no given htlm class", ->
      
      it "returns a div with the default class", ->
        div = '<div class="g-recaptcha" data-sitekey="public_site_key"></div>'
        recaptcha2.formElement().should.eql div
