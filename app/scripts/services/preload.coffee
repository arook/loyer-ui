'use strict'

###*
 # @ngdoc service
 # @name loyerApp.preload
 # @description
 # # preload
 # Factory in the loyerApp.
###
angular.module('loyerApp')
  .factory 'preload', ($q, $rootScope) ->

    # Preloader = (imageLocations) ->
    class Preloader

      constructor: (@imageLocations) ->
        @imageCount = @imageLocations.length
        @loadCount = 0
        @errorCount = 0
        @states =
          PENDING: 1
          LOADING: 2
          RESOLVED: 3
          REJECTED: 4
        @state = @states.PENDING
        @deferred = $q.defer()
        @promise = @deferred.promise

    # Preloader.prototype = {

      # constructor: Preloader

      isInitiated: ->
        @state isnt @states.PENDING

      isRejected: ->
        @state is @states.REJECTED

      isResolved: ->
        @state is @states.RESOLVED

      load: ->
        if @isInitiated()
          return @promise

        @state = @states.LOADING

        @loadImageLocation(location) for location in @imageLocations

        @promise

      handleImageError: (imageLocation) ->
        @errorCount++
        console.error "handleImageError #{imageLocation}: #{@errorCount}/#{@imageCount} ..."

        if @isRejected()
          return

        @state = @states.REJECTED

        @deferred.reject imageLocation

      handleImageLoad: (imageLocation) ->
        @loadCount++
        console.debug "handleImageLoad #{imageLocation}: #{@loadCount}/#{@imageCount} ..."

        if @isRejected()
          return 

        @deferred.notify {
          percent: Math.ceil(@loadCount/@imageCount * 100)
          imageLocation: imageLocation
        }

        if @loadCount is @imageCount
          @state = @states.RESOLVED
          @deferred.resolve @imageLocations
          console.info "resolve ... #{@imageLocations}"

      loadImageLocation: (imageLocation) =>
        console.debug 'loadImageLocation fired..'
        image = $(new Image()).load (event) =>
          console.debug "image #{event.target.src} loaded..."
          $rootScope.$apply =>
            @handleImageLoad event.target.src
            preloader = image = event = null
        .error (event) =>
          console.debug "image #{event.target.src} failed..."
          $rootScope.$apply =>
            @handleImageError event.target.src
            preloader = image = event = null
        .prop 'src', imageLocation

    Preloader.preloadImages = (imageLocations) ->
      preloader = new Preloader(imageLocations)
      console.log preloader
      preloader.load()
        
        
        
        

    # }

    Preloader
