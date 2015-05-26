'use strict'

###*
 # @ngdoc directive
 # @name loyerApp.directive:rating
 # @description
 # # rating
###
angular.module('loyerApp')
  .directive 'rating', ($ratingView, $timeout) ->
    restrict: 'A'
    scope:
      ngModel: '=ngModel'

    template: '<div></div>'
    link: (scope, element, attrs) ->
      element.append '<div/>'
      holder = element.children()[0]

      if scope.ngModel and scope.ngModel.$promise then scope.ngModel.$promise.then ->
        render()
      else scope.$watch 'ngModel', ->
        render()

      beh = if undefined isnt attrs.readonly then 'disable' else 'enable'

      render = ->
        React.render ($ratingView {value: scope.ngModel}), holder, ->
          $timeout ->
            $('.ui.rating', holder).rating(beh)
            $('.ui.rating', holder).rating 'setting', {
              onRate: (v) ->
                scope.$evalAsync ->
                  scope.ngModel = v
            }
          , 1000

      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder

  .factory '$ratingView', () ->
    {div} = React.DOM
    React.createClass
      render: ->
        div {className: 'ui rating large star', 'data-rating': Math.floor(@props.value), 'data-max-rating': 5}
