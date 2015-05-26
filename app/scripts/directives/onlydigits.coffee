'use strict'

angular.module('loyerApp')
  .directive('onlyDigits', () ->
    restrict: 'A'
    require: '?ngModel'
    link: (scope, element, attrs, ngModel) ->
      element.text 'this is the onlyDigits directive'
      ngModel.$parsers.unshift (inputValue) ->
      	digits = inputValue.split('').filter (s) ->
      		!isNaN(s) && s != ' '
      	.join('')
      	ngModel.$viewValue = digits
      	ngModel.$render()
      	digits
  )
