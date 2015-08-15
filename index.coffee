
Promise=require('bluebird')
request=require('request')


class Recaptcha2

  errorList={
    'request-error':'Api request failed .'
    'json-parse':'Response JSON pars failed.'
    'missing-input-secret':'The secret parameter is missing.'
    'invalid-input-secret':'The secret parameter is invalid or malformed.'
    'missing-input-response':'The response parameter is missing.'
    'invalid-input-response':'The response parameter is invalid or malformed.'
  }

  construct:(@config)->

    if @config.ssl is undefined
      @config.ssl=true

    if(@config.ssl)
      @api="https://www.google.com/recaptcha/api/siteverify"
    else
      @api="http://www.google.com/recaptcha/api/siteverify"



  validate:(response='',remoteip)->

    return new Promise (resolve,reject)->


      if response == ''
        # no need to ask google it's invalid , i have no time to wast
        return reject(['missing-input-response'])

      # REQUEST_START
      request.post(@api,{
        secret:@config.secretKey
        response:response
        remoteip:remoteip
      },(error,response,body)->
        if error
          return reject(['request-error'])
        else
          try
            result=JSON.parse body
            if result.success
              return accept(true)
            else
              return reject(result['error-codes'])
          catch tryErr
            return reject(['request-error','json-parse'])
      )
      # REQUEST_END

  validateRequest:(req)->
    return @validate(req.body['g-recaptcha-response'])

  translateErrors:(errorCodes)->
    if Array.isArray errorCodes
      ret=[]
      for key in errorCodes
        ret.push errorList[key]||''
      return ret
    else
      return errorList[key]||''


  formElement:(htmlClass)->
    return """<div class="#{htmlClass||'g-recaptcha'}" data-sitekey="#{@config.siteKey}"></div>"""
















module.exports=Recaptcha2
