'use strict'

angular.module('loyerApp')
  .controller 'CollectionmodalCtrl', ($scope, $routeParams, $location, Cart, Store) ->

    $scope.order = {}
    $scope.order.$amount = ->
      amount = 0
      angular.forEach this, (detail, key) ->
        if key != '$amount'
          amount += parseInt(detail.$qty()) * parseInt(detail.price)
      amount

    Store.resource('security', 'collections', $routeParams.id).get (rtn) ->
      $scope.slides = [
        {image: "/front/asset/collections/#{rtn.id}/1/jpg"}
        {image: "/front/asset/collections/#{rtn.id}/2/jpg"}
        # {image: "/front/asset/collections/#{rtn.id}/3/jpg"}
      ]
      # handle sizes && orders
      angular.forEach rtn.detail, (detail, key) ->
        if ! $scope.order[detail.product.id]
          $scope.order[detail.product.id] = {
            price: detail.product.price
            $qty: ->
              qty = 0
              angular.forEach this, (value, color_code) ->
                if color_code != '$qty' and color_code != 'price'
                  angular.forEach value, (count, size_value) ->
                    if size_value != '$qty'
                      qty += parseInt(count)
              qty
          }
        $scope.order[detail.product.id][detail.color.color.code] = {
          $qty: ->
            qty = 0
            angular.forEach this, (value, size_code) ->
              if size_code != '$qty'
                qty += parseInt(value)
            qty
        }

        # fill the qty from cache
        Cart.init().$promise.then ->
          angular.forEach Cart.getCollection(detail.product.id, $routeParams.id), (item) ->
            $scope.order[detail.product.id][detail.color.color.code][item.size] = item.qty

        angular.forEach detail.product.sizes, (size, k) ->
          rtn.detail[key]['product'][size.size.value] = size.size

      $scope.collection = rtn

    $scope.change_all_to = (num) ->
      angular.forEach $scope.collection.detail, (item, key) ->
        ($scope.order[item.product.id][item.color.color.code]["S#{k}"] = num if item.product["S#{k}"]) for k in [1..6]

    $scope.change_to = (num, item = 0) ->
      if 0 is item
        $scope.change_all_to num
      else
        ($scope.order[item.product.id][item.color.color.code]["S#{k}"] = num if item.product["S#{k}"]) for k in [1..6]


    $scope.ok = ->
      angular.forEach $scope.order, (value, gid) ->
        if gid != '$amount'
          angular.forEach value, (sizes, color) ->
            if color != 'price' and color != '$qty'
              angular.forEach sizes, (qty, size) ->
                Cart.addItem parseInt(gid), color, size, parseInt(value.price), parseInt(qty), parseInt($routeParams.id), 0, 'collection'
      Cart.save().$promise.then ->
        $location.path '/collection'

    $scope.cancel = ->
      $location.path '/collection'

