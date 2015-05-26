'use strict'

###*
 # @ngdoc directive
 # @name loyerApp.directive:dropDown
 # @description
 # # dropDown
###
angular.module('loyerApp')
  .directive 'dropDown', ($dropDownView) ->
    restrict: 'A'
    require: 'ngModel'
    replace: true
    transclude: true
    scope: {
      ngModel: '=ngModel'
      title: '@'
      options: '=options'
      label: '@'
    }
    link: (scope, element, attrs) ->
      element.append '<div/>'
      holder = element.children()[0]
      readonly = if attrs.readonly then true else false
      required = if attrs.required then true else false

      render = ->
        React.renderComponent ($dropDownView {caption: attrs.caption, label: scope.label, title: scope.title, options: scope.options, value: scope.ngModel, readonly: readonly, required: required, size: attrs.size}), holder, ->
          $('.ui.dropdown', holder).dropdown {
            onChange: (v, t, $choice) ->
              if '---' is v
                v = ''
              scope.$evalAsync ->
                scope.ngModel = v
          }

      if scope.options and scope.options.$promise then scope.options.$promise.then ->
        render()
      else scope.$watch 'options', ->
          render()

      scope.$on '$destroy', ->
        React.unmountComponentAtNode holder
  .factory '$dropDownView', () ->
    {div, label, input, i} = React.DOM
    React.createClass
      getInitialState: ->
        selectedValue: '---'
      componentDidMount: ->
        @setState selectedValue: @props.value or '---'
      handleChange: (e) ->
        @setState selectedValue: e.target.getAttribute('data-value'), value: e.target.getAttribute('data-value')
      render: ->
        div {className: ''}, [
          label {key: 'label'}, @props.caption if @props.caption
          div {key: 'divdropdown', className: 'ui input search selection dropdown ' + @props.size + ' ' + (if @props.required and '---' is @state.selectedValue then 'error' else '')}, [
            input {key: 'hidden', type: 'hidden', defaultValue: @props.value}, ''
            div {key: 'default', className: 'default text'}, @props.title
            i {key: 'icon', className: 'dropdown icon'}, ''
            div {key: 'divmenu', className: 'menu'}, [
              div {key: 'itemDefault', className: 'item', 'data-value': '---', onClick: @handleChange}, @props.title
              div {key: "item#{o.id}", className: 'item', 'data-value': o.id, onClick: @handleChange}, o[@props.label] for o in @props.options if @props.options
            ]
          ]
        ]
        # select {className: 'ui dropdown search ' + (if @props.required and '0' is @state.selectedValue then 'error' else ''), defaultValue: @props.value, onChange: @handleChange, value: @state.value}, [
        #   option {value: '0'}, @props.title
        #   option {value: o.id}, o[@props.label] for o in @props.options if @props.options
        #   option {value: 1000000}, @state.selectedValue
        # ]
