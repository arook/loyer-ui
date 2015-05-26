'use strict'

angular.module('loyerApp')
  .filter 'percent', ($filter) ->
    (input, decimals) ->
      $filter('number')(input*100, decimals) + '%'
