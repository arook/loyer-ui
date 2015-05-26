'use strict'

angular.module('loyerApp')
  .controller 'PreselectionCtrl', ($scope, $location, Store, Authentication) ->

    $scope.goods = []
    watches = []

    Store.resource('security', 'goods').query {type: 'preselection', count: 1024, order: 'rand'}, (rtn) ->
      angular.forEach rtn, (value, key) ->
        value.images.push {url: "http://120.25.121.245:8889/Files/#{value.number}.jpg"}
        value.rating = {}

        for star in value.stars
          value.rating["#{star.product_color_id}"] = star.star if star.product_color_id > 0
        
        $scope.goods[key] = value

        watches.push $scope.$watch ->
          value.rating
        , (newValue, oldValue)->
          if newValue isnt oldValue then Store.resource('security', 'goods').save {id: value.id, params: newValue}, (rtn) ->
              console.debug 'rating ok!', rtn
        , true

    $scope.$on '$destroy', ->
      watch() for watch in watches
