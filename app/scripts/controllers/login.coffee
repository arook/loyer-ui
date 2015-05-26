'use strict'

angular.module('loyerApp')
  .controller 'LoginCtrl', ($scope, $location, Authentication) ->
	
  	$scope.input =
  	  	login: ''
  	  	code: ''
  	  	password: ''

    $scope.loginToP = () ->
      Authentication.login $scope.input, ->
        #$location.path '/preselection'
        $location.path '/choosen'

  	$scope.loginToD = () ->
  		Authentication.login $scope.input, ->
  			$location.path '/'

  	$scope.loginToR = () ->
  		Authentication.login $scope.input, ->
  			$location.path '/repl'