'use strict'

angular.module('loyerApp')
  .controller 'NewsCtrl', ($scope, Store, Authentication) ->

    Store.resource('security', 'news').query (rtn) ->
      $scope.news_list = rtn

    $scope.storename = ->
      Authentication.storename()

    $scope.logout = ->
      Authentication.logout () ->
        $location.path '/login'

    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
