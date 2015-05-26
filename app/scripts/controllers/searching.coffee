'use strict'

angular.module('loyerApp')
  .controller 'SearchingCtrl', ($scope, Store) ->

    $scope.kw = '0001'

    $scope.search = ->
      Store.resource('searching', $scope.kw).get (rtn) ->
        $scope.product = rtn
