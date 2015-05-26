'use strict'

angular.module('loyerApp')
  .directive('preselection', () ->
    template: '<div></div>'
    restrict: 'E'
    scope:
      data: '=data'
    link: (scope, element, attrs) ->
      element.text scope.data
  )
