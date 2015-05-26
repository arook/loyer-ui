'use strict'

angular.module('loyerApp')
  .filter 'range', () ->
    (input, max) ->
      max = Math.ceil max
      input = (i for i in [1..max])