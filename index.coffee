
Promise=require('bluebird')
request=require('request')


class Recaptcha2

  errorList={
    'request-error':'Api request failed .'
    'json-parse':'Response JSON parse failed.'
    'missing-input-secret':'The secret parameter is missing.'
    'invalid-input-secret':'The secret parameter is invalid or malformed.'
    'missing-input-response':'The response parameter is missing.'
    'invalid-input-response':'The response parameter is invalid or malformed.'
  }

  constructor:(@config)->

    if @config.ssl is undefined
      @config.ssl=true

    if(@config.ssl)
      @api="https://www.google.com/recaptcha/api/siteverify"
    else
      @api="http://www.google.com/recaptcha/api/siteverify"




  validate:(response='',remoteip)->
    $=@
    return new Promise (resolve,reject)->


      if response == ''
# no need to ask google it's invalid , i have no time to wast
        return reject(['missing-input-response'])

      # REQUEST_START
      options={
        url:$.api
        method:'POST'
        form:
          secret:$.config.secretKey
          response:response
      }

      if remoteip isnt undefined
        options.form.remoteip=remoteip

      request(options,(error,response,body)->
        if error
          return reject(['request-error',error.toString()])
        else
          try
            result=JSON.parse body
            if result.success
              return resolve(true)
            else
              return reject(result['error-codes'])
          catch tryErr
            return reject(['request-error','json-parse'])
      )
# REQUEST_END

  validateRequest:(req, ip)->
    return @validate(req.body['g-recaptcha-response'],ip)

  translateErrors:(errorCodes)->
    if Array.isArray errorCodes
      ret=[]
      for key in errorCodes
        ret.push errorList[key]||key
      return ret
    else
      return errorList[key]||key


  formElement:(htmlClass)->
    return """<div class="#{htmlClass||'g-recaptcha'}" data-sitekey="#{@config.siteKey}"></div>"""





module.exports=Recaptcha2
