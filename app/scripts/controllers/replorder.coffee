'use strict'

angular.module('loyerApp')
.controller 'ReplorderCtrl', ($scope, $location, Store, Repl, Authentication) ->

	Store.resource('security', 'repl').query {type: 'oid'}, (rtn) ->
		$scope.order = rtn[0] if rtn.length > 0

	Repl.init()
	$scope.tops_type = 'category'
	[$scope.show_summary, $scope.show_tops, $scope.show_detail] = [false, false, false]
	$scope.btn_summary = ->
		[$scope.show_summary, $scope.show_tops, $scope.show_detail] = [true, false, false]
		$scope.summary = Repl.summary()
	$scope.btn_tops = ->
		[$scope.show_summary, $scope.show_tops, $scope.show_detail] = [false, true, false]
		$scope.tops = Repl.tops($scope.tops_type)
	$scope.btn_detail = ->
		[$scope.show_summary, $scope.show_tops, $scope.show_detail] = [false, false, true]
		$scope.details = Repl.detail()

	$scope.change_tops_type = (t) ->
		$scope.tops_type = t
		$scope.btn_tops()

	$scope.btn_submit = ->
		if window.confirm "确定要提交订单么？"
			Repl.submit()
			$location.path '/repl'

		# bootbox.confirm "确定要清空购物车么？", (result) ->
		# 	if result
		# 		Repl.submit()
		# 		$location.path '/repl'
		# false

	$scope.btn_detail()

	$scope.empty = ->
		if window.confirm "确定要清空购物车么？"
			Repl.empty()
			$scope.btn_detail()
		
		# bootbox.confirm "确定要清空购物车么？", (result) ->
		# 	if result
		# 		Repl.empty()
		# 		$scope.btn_detail()
		# false

