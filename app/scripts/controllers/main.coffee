'use strict'

angular.module('loyerApp')
  .controller 'MainCtrl', ($scope, $location, Store, Authentication, Cart, $meta, Cache) ->

    $scope.categories = $meta 'categories'
    $scope.periods = $meta 'periods'
    $scope.series = $meta 'series'

    $scope.filter = if null isnt Cache.get('vdt.order.filter') then Cache.get('vdt.order.filter') else {}
    $scope.$watch 'filter', (v) ->
      fetching($scope.page_number, v, true)
      Cache.set 'vdt.order.filter', v
    , true

    $scope.goods = []
    # init cart
    Cart.init().$promise.then ->
      $scope.$watch 'goods', ->
        angular.forEach $scope.goods, (v) ->
          v.oc = Cart.oc(v.id)

    fetching = (pn = 1, filter = $scope.filter, rebuild = false) ->
      if rebuild
        $scope.goods = []
        $scope.page_number = 1
      
      Store.resource('security', 'goods').query {pn: pn, number: filter.number, period: filter.period, category: filter.category, series: filter.series}, (rtn) ->
        $scope.goods = $scope.goods.concat(rtn)

    $scope.page_number = 1
    # fetching($scope.page_number)

    $scope.loadMore = ->
      fetching($scope.page_number = $scope.page_number + 1)

