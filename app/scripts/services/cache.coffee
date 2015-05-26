'use strict'

###*
 # @ngdoc service
 # @name loyerApp.Cache
 # @description
 # # Cache
 # Factory in the loyerApp.
###
angular.module('loyerApp')
  .factory 'Cache', ->
    # Service logic
    # ...

    meaningOfLife = 42

    # Public API here
    {
      get: (key) ->
        JSON.parse localStorage.getItem(key)
      set: (key, val) ->
        localStorage.setItem key, JSON.stringify(val)
      unset: (key) ->
        localStorage.removeItem key
      clear: ->
        localStorage.clear()
    }
