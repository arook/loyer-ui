'use strict'

angular.module('loyerApp')
.controller 'Modal1Ctrl', ($scope, $routeParams, $location, Repl, Store) ->
  $scope.order = {}
  Store.resource('security', 'goods', $routeParams.id).get (rtn) ->
    $scope.item = rtn
    angular.forEach rtn.colors, (value, key) ->
      $scope.order[value.color.code] = {}
    Repl.init().$promise.then ->
      angular.forEach Repl.getItem($routeParams.id), (item) ->
        $scope.order[item.color][item.size] = item.qty


  $scope.change_all_to = (num) ->
    angular.forEach $scope.item.colors, (value, key) ->
      angular.forEach $scope.item.sizes, (v, k) ->
        $scope.order[value.color.code][v.size.value] = num

  $scope.change_to = (num, color_code = 0) ->
    if 0 is color_code
      $scope.change_all_to(num)
    else
      angular.forEach $scope.item.sizes, (v, k) ->
        if $scope.item.sizes.length >=3 and k >= 1 and k < ($scope.item.sizes.length - 1)
          $scope.order[color_code][v.size.value] = num + 1
        else
          $scope.order[color_code][v.size.value] = num

  $scope.sumcolor = (code) ->
    sum = 0
    angular.forEach $scope.order[code], (value, key) ->
      sum += parseInt(value)
    sum

  $scope.sumsize = (code) ->
    sum = 0
    angular.forEach $scope.order, (value, key) ->
      angular.forEach value, (v, k) ->
        if k == code
          sum += parseInt(v)
    sum

  $scope.sumall = ->
    sum = 0
    angular.forEach $scope.order, (value, key) ->
      angular.forEach value, (v, k) ->
        sum += parseInt(v)
    sum

  $scope.ok = ->
    angular.forEach $scope.order, (value, color) ->
        angular.forEach value, (qty, size) ->
            Repl.addItem $routeParams.id, color, size, $scope.item.price, parseInt(qty)
    Repl.save().$promise.then ->
      $location.path '/repl'

  $scope.back = ->
    $location.path '/repl'
