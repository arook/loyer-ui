'use strict'

angular.module('loyerApp')
  .controller 'CollectionCtrl', ($scope, $location, Store, Authentication, Cart) ->

    $scope.goods = []

    Cart.init().$promise.then ->
      $scope.$watch 'goods', ->
        angular.forEach $scope.goods, (v) ->
          v.oc = (Cart.cc v.id)

    Store.resource('security', 'collections').query (rtn) ->
      $scope.goods = $scope.goods.concat(rtn)

    # $scope.detail = (cid) ->
    #   $modal.open({
    #     templateUrl: 'views/collection-detail.html'
    #     controller: 'CollectionmodalCtrl'
    #     resolve: {
    #       cid: ->
    #         cid
    #     }
    #   }).result.then (order) ->
    #     console.log order
    #     # gid, color, size, price, qty, cid
    #     angular.forEach order, (value, gid) ->
    #       if gid != '$amount'
    #         angular.forEach value, (sizes, color) ->
    #           if color != 'price' and color != '$qty'
    #             angular.forEach sizes, (qty, size) ->
    #               Cart.addItem parseInt(gid), color, size, parseInt(value.price), parseInt(qty), parseInt(cid), 0, 'collection'
    #     Cart.save()
    #     angular.forEach $scope.goods, (v) ->
    #       if v.id == cid
    #         v.oc = Cart.cc(v.id)

