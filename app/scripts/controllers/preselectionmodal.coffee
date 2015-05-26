'use strict'

angular.module('loyerApp')
  .controller 'PreselectionmodalCtrl', ($scope, $modalInstance, gid, Cart, Store) ->
    $scope.order = {}
    Store.resource('security', 'goods', gid).get (rtn) ->
      angular.forEach rtn.colors, (value, key) ->
        $scope.order[value.color.code] = {}
      angular.forEach Cart.getItem(gid), (item) ->
        $scope.order[item.color][item.size] = item.qty
        console.debug item.qty
      console.debug $scope.order
      $scope.slides = [
        {image: "http://120.25.121.245:8889/Files/#{rtn.number}.jpg"},
        {image: "http://120.25.121.245:8889/Files/#{rtn.number} (1).jpg"},
        {image: "http://120.25.121.245:8889/Files/#{rtn.number} (2).jpg"},
        {image: "http://120.25.121.245:8889/Files/#{rtn.number} (3).jpg"},
        {image: "http://120.25.121.245:8889/Files/#{rtn.number} (4).jpg"},
        {image: "http://120.25.121.245:8889/Files/#{rtn.number} (5).jpg"},
        {image: "http://120.25.121.245:8889/Files/#{rtn.number} (6).jpg"},
        {image: "http://120.25.121.245:8889/Files/#{rtn.number} (7).jpg"},
        {image: "http://120.25.121.245:8889/Files/#{rtn.number} (8).jpg"}]
      $scope.item = rtn
      $scope.$watch 'item.stars', ->
        angular.forEach $scope.item.stars, (value, key) ->
          if value > 0
            Store.resource('security', 'goods').save {id: gid, color_id: key, star: value}, (rtn) ->
              console.debug rtn
      , true

          
      # $scope.$watch 'item.star', ->
      #   if $scope.item.star > 0
      #     Store.resource('security', 'goods').save {id: gid, star: $scope.item.star}, (rtn) ->
      #       console.debug rtn

    $scope.like = (id) ->
      console.log id
    
    $scope.voted = ->
      voted = false
      angular.forEach $scope.item.stars, (value, key) ->
        if value > 0
          voted = true
      voted

    $scope.ok = ->
      if ! $scope.voted()
        alert('亲，请先评个分吧～')
      else
        $modalInstance.close($scope.order)

    $scope.cancel = ->
      if ! $scope.voted()
        alert('亲，请先评个分吧～')
      else
        $modalInstance.dismiss('cancel')
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
