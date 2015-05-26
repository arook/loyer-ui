'use strict'

angular.module('loyerApp')
.controller 'OrderCtrl', ($scope, $location, Store, Cart, Authentication) ->

	$scope.rtn = $location.search().rtn

	Store.resource('security', 'order').query {type: 'oid'}, (rtn) ->
		$scope.order = rtn[0] if rtn.length > 0

	Cart.init()
	$scope.tops_type = 'category'
	[$scope.show_summary, $scope.show_tops, $scope.show_detail, $scope.show_top, $scope.show_stars] = [false, false, false, false, false]
	$scope.btn_summary = ->
		[$scope.show_summary, $scope.show_tops, $scope.show_detail, $scope.show_top, $scope.show_stars] = [true, false, false, false, false]
		$scope.summary = Cart.summary()
	$scope.btn_tops = ->
		[$scope.show_summary, $scope.show_tops, $scope.show_detail, $scope.show_top, $scope.show_stars] = [false, true, false, false, false]
		$scope.tops = Cart.tops($scope.tops_type)
	$scope.btn_detail = ->
		[$scope.show_summary, $scope.show_tops, $scope.show_detail, $scope.show_top, $scope.show_stars] = [false, false, true, false, false]
		$scope.details = Cart.detail()
	$scope.btn_top = ->
		[$scope.show_summary, $scope.show_tops, $scope.show_detail, $scope.show_top, $scope.show_stars] = [false, false, false, true, false]
		$scope.top = Cart.top()
	$scope.btn_stars = ->
		[$scope.show_summary, $scope.show_tops, $scope.show_detail, $scope.show_top, $scope.show_stars] = [false, false, false, false, true]
		Store.resource('security', 'stars').query {type: 'order'}, (rtn) =>
			$scope.stars = rtn
		Store.resource('security', 'stars').query {type: 'order', mine: 'mine'}, (rtn) =>
			$scope.mine = rtn

	$scope.change_tops_type = (t) ->
		$scope.tops_type = t
		$scope.btn_tops()

	$scope.btn_submit = ->
		if window.confirm "确定要提交订单么？"
			Cart.submit()
			$location.path '/main'

	$scope.btn_detail()

	$scope.empty = ->
		if window.confirm "确定要清空购物车么？"
			Cart.empty()
			$scope.btn_detail()
