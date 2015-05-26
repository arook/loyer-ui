'use strict'

angular.module('loyerApp')
  .service 'Authentication', ($resource, $sanitize, $location, $q, $cookies, Store, Meta) ->
    # AngularJS will instantiate a singleton by calling "new" on this function

    store = Store.resource 'login', '', null, {
    	login: {method: 'POST'}, logout: {method: 'GET'}
    }

    loginError = (resp) ->
    	alert resp.data.error.message


    sanitizeCredentials = (credentials) ->
      {
        login: $sanitize(credentials.login),
        code: $sanitize(credentials.code),
        password: $sanitize(credentials.password)
      }

    service =
        login: (credentials, success) ->
            Meta.flush()
            store.login sanitizeCredentials(credentials), (rtn) ->
                # localStorage.setItem 'token', rtn.publicToken
                $cookies.token = rtn.publicToken
                $cookies.storename = rtn.storename
                success()
            , loginError

        logout: (success) ->
            # localStorage.removeItem 'token'
            $cookies.token = ''
            success()
        storename: ->
          $cookies.storename

        isLoggedIn: ->
            '' isnt $cookies.token and undefined isnt $cookies.token
