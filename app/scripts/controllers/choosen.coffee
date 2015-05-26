'use strict'

angular.module('loyerApp')
  .controller 'ChoosenCtrl', ($scope, $q, $interval, Store, Meta, Cache, preload) ->


    preLoadPreselectionImages = ->
      console.debug 'preLoadPreselectionImages ...'
      KEY = 'vdt.preload.preselection.images'
      deferred  = $q.defer()
      deferred.$promise = deferred.promise

      if images = Cache.get KEY
        deferred.resolve images
        images
      else
        http = Meta.store('/front/security/goods').query {type: 'preselection', count: 1024}
        http.$promise.then (rtn) =>
          images = []
          angular.forEach rtn, (value, key) ->
            images.push "http://120.25.121.245:8889/Files/#{value.number}.jpg"
            angular.forEach value.images, (value, key) ->
              images.push value.url
          Cache.set KEY, images
          deferred.resolve images
      deferred

    preLoadCollectionImages = ->
      console.debug 'preLoadCollectionImages ...'
      KEY = 'vdt.preload.collection.images'
      deferred  = $q.defer()
      deferred.$promise = deferred.promise

      if images = Cache.get KEY
        deferred.resolve images
        images
      else
        http = Meta.store('/front/security/collections').query {}
        http.$promise.then (rtn) =>
          images = []
          angular.forEach rtn, (value, key) ->
            images.push "/front/asset/collections/#{value.id}/1/jpg"
            angular.forEach value.images, (value, key) ->
              images.push value.url
          Cache.set KEY, images
          deferred.resolve images
      deferred

    preLoadOrderingImages = ->
      console.debug 'preLoadOrderingImages ...'
      KEY = 'vdt.preload.order.images'
      deferred  = $q.defer()
      deferred.$promise = deferred.promise

      if images = Cache.get KEY
        deferred.resolve images
        images
      else
        http = Meta.store('/front/security/goods').query {type: 'order', count: 1024}
        http.$promise.then (rtn) =>
          images = []
          angular.forEach rtn, (value, key) ->
            images.push "http://120.25.121.245:8889/Files/#{value.number}.jpg"
            angular.forEach value.images, (value, key) ->
              images.push value.url
          Cache.set KEY, images
          deferred.resolve images
      deferred

    preLoadReplenishingImages = ->
      console.debug 'preLoadReplenishingImages ...'
      KEY = 'vdt.preload.repl.images'
      deferred  = $q.defer()
      deferred.$promise = deferred.promise

      if images = Cache.get KEY
        deferred.resolve images
        images
      else
        http = Meta.store('/front/security/goods').query {type: 'repl', count: 1024}
        http.$promise.then (rtn) =>
          images = []
          angular.forEach rtn, (value, key) ->
            images.push "http://120.25.121.245:8889/Files/#{value.number}.jpg"
            angular.forEach value.images, (value, key) ->
              images.push value.url
          Cache.set KEY, images
          deferred.resolve images
      deferred

    # 暂时不用这个方案
    getImages = ->
      deferred  = $q.defer()
      if images = Cache.get 'vdt.preload.images'
        console.debug 'from cache...'
        images.$promise = deferred.promise
        deferred.promise.then (images) ->
          images
        deferred.resolve images
        images
      else
        console.debug 'from remote'
        deferred.$promise = deferred.promise
        deferred.promise.then (images) ->
          images

        images = []
        [ta, tb, tc, td] = [false, false, false, false]
        preLoadPreselectionImages().$promise.then (rtn) ->
          images = images.concat rtn
          ta = true
        preLoadCollectionImages().$promise.then (rtn) ->
          images = images.concat rtn
          tb = true
        preLoadOrderingImages().$promise.then (rtn) ->
          images = images.concat rtn
          tc = true
        preLoadReplenishingImages().$promise.then (rtn) ->
          images = images.concat rtn
          td = true

        checking = $interval ->
          deferred.notify "status: TA: #{ta}, TB: #{tb}, TC: #{tc}, TD: #{td}"
          console.debug "status: TA: #{ta}, TB: #{tb}, TC: #{tc}, TD: #{td}"
          if ta and tb and tc and td
            deferred.resolve images
            $interval.cancel checking
        , 1000

        deferred


    loading = (imageLocations, signal) ->
      preload.preloadImages(imageLocations).then ->
        $scope["is#{signal}Loading"] = false
        console.info "#{signal} preload successful"
      , (imageLocation) ->
        $scope["is#{signal}Loading"] = false
        console.error "#{signal} Image Failed", imageLocation
      , (event) ->
        console.debug "#{signal} Percent loaded:", event.percent
        $("#loading#{signal}Bar").progress {percent: event.percent}

    # 入口
    init = ->
      $scope.isPLoading = $scope.isOLoading = $scope.isCLoading = $scope.isRLoading = false

      Store.resource('config', '').get (rtn) ->
        $scope.config = rtn
        $scope.openedCount = parseInt(rtn.if_staring_online) + parseInt(rtn.if_ordering_online) + parseInt(rtn.if_replenishing_online)

    $scope.preloadA = ->
      $scope.isPLoading = true
      preLoadPreselectionImages().$promise.then (images) ->
        loading(images, 'P')

    $scope.preloadB = ->
      $scope.isOLoading = true
      $scope.isCLoading = true
      preLoadCollectionImages().$promise.then (images) ->
        loading(images, 'C')

      preLoadOrderingImages().$promise.then (images) ->
        loading(images, 'O')

    $scope.preloadC = ->
      $scope.isRLoading = true
      preLoadReplenishingImages().$promise.then (images) ->
        loading(images, 'R')

    init()



