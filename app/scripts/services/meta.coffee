'use strict'

###*
 # @ngdoc service
 # @name loyerApp.Meta
 # @description
 # # Meta
 # Service in the loyerApp.
###
angular.module('loyerApp')
  .service 'Meta', ($resource, Cache, $location) ->
    # AngularJS will instantiate a singleton by calling "new" on this function
    @config =
      page:
        size: Cache.get 'config.page.size' || 15
      schema: $location.protocol()
      host: $location.host()
      port: $location.port()

    rtn =
      config: @config
      store: (url, paramDefaults, actions) ->
        $resource(@config.schema + '://' + @config.host + ':' + @config.port + url, paramDefaults, angular.extend {update: {method: 'put'}}, actions)

      cache: (url, paramDefaults, actions) ->
        $resource(@config.schema + '://' + @config.host + ':' + @config.port + url, paramDefaults, angular.extend {query: {method: 'get', isArray: true, cache: true}}, actions)

      flush: ->
        Cache.clear()

  .service '$meta', ($q, Meta, Cache) ->
    @mapping =
      # 公共

      categories: key: 'vdt.list.category', url: '/front/security/filter?t=categories'
      periods: key: 'vdt.list.period', url: '/front/security/filter?t=periods'
      series: key: 'vdt.list.series', url: '/front/security/filter?t=series'


    @getKey = (key) ->
      @mapping[key]['key']

    @getUrl = (key) ->
      @mapping[key]['url']

    @fetch = (key) ->
      http = Meta.store(@getUrl key).query()
      http.$promise.then (rtn) =>
        Cache.set (@getKey key), rtn
      http

    # return $promise
    (key, refresh = false) =>
      if not refresh and rs = Cache.get(@getKey key)
        deferred = $q.defer()
        rs.$promise = deferred.promise
        deferred.promise.then (rs) ->
          rs
        deferred.resolve rs
        rs
      else
        @fetch key

