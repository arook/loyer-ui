'use strict'

###*
 # @ngdoc function
 # @name loyerApp.controller:VdtDefaultCtrl
 # @description
 # # VdtDefaultCtrl
 # Controller of the loyerApp
###
angular.module('loyerApp')
  .controller 'VdtDefaultCtrl', ($scope, $location, Authentication, Repl, Cart, Meta) ->
    $scope.user = {name: 'hello'}
    
    $scope.isLogin = () ->
      Authentication.isLoggedIn()
      
    $scope.logout = () ->
      Authentication.logout () ->
        $location.path '/login'
    
    $scope.storename = ->
      Authentication.storename()

    $scope.total_repl = ->
        Repl.total()
    
    $scope.amount_repl = ->
        Repl.amount()

    $scope.total_main = ->
        Cart.total()
    
    $scope.amount_main = ->
        Cart.amount()

    $scope.routeIs = (routeName) ->
      $location.path().indexOf(routeName) == 0

    Meta.store('/front/config').get (rtn) ->
      $scope.config = rtn
    
    # UI
    $('.ui.dropdown').dropdown {
      # on: 'hover'
    }
