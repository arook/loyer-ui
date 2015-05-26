'use strict'

###*
 # @ngdoc directive
 # @name loyerApp.directive:MenuView
 # @description
 # # MenuView
###
angular.module('loyerApp')
  .directive 'menuView', ($menuView) ->
    restrict: 'EA'
    socpe:
      user: '='
      cart: '='
    link: (scope, element, attrs) ->
      element.append '<div/>'
      holder = element.children()[0]
      
      render = () ->
        React.render ($menuView {user: scope.user, cart: scope.cart}), holder, ->
          console.log 'hello there'
      
      scope.$watch 'user', ->
        render()

      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder

  .factory '$menuView', ($menuTitle) ->
    {div, a, i} = React.DOM
    React.createClass
      componentDidMount: ->
        console.log 'did mounent...'
      render: ->
        div {className: 'ui menu small'}, [
          a {className: 'active item'}, [
            $menuTitle {name: @props.user.name}
          ]
        ]
  .factory '$menuTitle', () ->
    {i} = React.DOM
    React.createClass
      render: ->
        i {className: 'home icon'}, @props.name
