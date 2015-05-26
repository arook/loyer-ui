'use strict'

angular.module('loyerApp')
  .controller 'ReplCtrl', ($scope, $location, Store, Authentication, Repl, $meta, Cache) ->

    $scope.show_img = true

    $scope.categories = $meta 'categories'
    $scope.periods = $meta 'periods'
    $scope.series = $meta 'series'

    $scope.filter = if null isnt Cache.get('vdt.repl.filter') then Cache.get('vdt.repl.filter') else {}
    $scope.$watch 'filter', (v) ->
      fetching($scope.page_number, v, true)
      Cache.set 'vdt.repl.filter', v
    ,true

    $scope.goods = []
    Repl.init().$promise.then ->
      $scope.$watch 'goods', ->
        angular.forEach $scope.goods, (v) ->
          v.oc = Repl.oc(v.id)

    fetching = (pn = 1, filter = $scope.filter, rebuild = false) ->
      if rebuild
        $scope.goods = []
        $scope.page_number = 1
      $scope.ifLoading = true
      Store.resource('security', 'goods').query {type: 'repl', pn: pn, number: filter.number, period: filter.period, category: filter.category, series: filter.series}, (rtn) ->
        $scope.goods = $scope.goods.concat(rtn)
        $scope.ifLoading = false


    $scope.page_number = 1

    $scope.ifLoading = false;
    $scope.loadMore = ->
      fetching($scope.page_number = $scope.page_number + 1)
