'use strict'

###*
 # @ngdoc directive
 # @name loyerApp.directive:vdtSlick
 # @description
 # # vdtSlick
###
angular.module('loyerApp')
  .directive 'vdtSlick', ($sliderView, $timeout) ->
    restrict: 'A'
    scope:
      items: '=items'
    link: (scope, element, attrs) ->
      element.append('<div/>')
      holder = element.children()[0]

      render = ->
        React.render ($sliderView {items: scope.items, key: attrs.key}), holder, ->
          console.log 'rendered from directive....'
          $timeout ->
            $('.slick', holder).slick {
              lazyLoad: 'ondemand',
              # slidesToShow: 2,
              dots: true
              arrows: true
              adaptiveHeight: false
              # mobileFirst: true
              # autoplay: true
              touchThreshold: 3
            }
          , 1000

      if scope.items and scope.items.$promise then scope.items.$promise.then ->
        render()
      else scope.$watch 'items', ->
        render()

      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder

  .factory '$sliderView', () ->
    {div, img} = React.DOM
    React.createClass
      render: ->
        div {className: 'ui slick'}, [
          if @props.items
            for item, key in @props.items
              div {key: "div_#{key}", className: 'ui borderd image'}, [
                if key is 0
                  img {key: "img_#{key}", 'src': "#{item.url}", className: ''}
                else
                  img {key: "img_#{key}", 'data-lazy': "#{item.url}", className: ''}
              ]
        ]
