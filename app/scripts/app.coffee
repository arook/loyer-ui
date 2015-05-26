'use strict'

angular.module('loyerApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        redirectTo: '/choosen'
      .when '/main',
        # redirectTo: '/preselection'
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/main/item/:id',
        templateUrl: 'views/detail.html'
        controller: 'ModalCtrl'
      .when '/main/order',
        templateUrl: 'views/order.html'
        controller: 'OrderCtrl'
      .when '/collection',
        templateUrl: 'views/collection.html'
        controller: 'CollectionCtrl'
      .when '/collection/item/:id',
        templateUrl: 'views/collection-detail.html'
        controller: 'CollectionmodalCtrl'
      .when '/repl',
        templateUrl: 'views/repl.html'
        controller: 'ReplCtrl'
      .when '/repl/item/:id',
        templateUrl: 'views/detail.html'
        controller: 'Modal1Ctrl'
      .when '/repl/order',
        templateUrl: 'views/repl.order.html'
        controller: 'ReplorderCtrl'
      .when '/login',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
      .when '/preselection',
        templateUrl: 'views/preselection.html'
        controller: 'PreselectionCtrl'
      .when '/choosen',
        templateUrl: 'views/choosen.html'
        controller: 'ChoosenCtrl'
      .when '/news',
        templateUrl: 'views/news.html'
        controller: 'NewsCtrl'
      .when '/searching',
        templateUrl: 'views/searching.html'
        controller: 'SearchingCtrl'
      .when '/vdt-default',
        templateUrl: 'views/vdt-default.html'
        controller: 'VdtDefaultCtrl'
      .otherwise
        redirectTo: '/'
  .config ($httpProvider) ->
    $httpProvider.interceptors.push ['$q', '$location', '$cookies', ($q, $location, $cookies) ->
      'request': (config) ->
        $httpProvider.defaults.headers.common['X-AUTH-TOKEN'] = $cookies.token
        config || $q.when config
      'responseError': (rejection) ->
        console.error rejection.data.error.message
        $location.path('/login')
        $q.reject rejection
    ]
  .config ($sceDelegateProvider) ->
    $sceDelegateProvider.resourceUrlWhitelist(['self', 'http://localhost:8000/**'])
