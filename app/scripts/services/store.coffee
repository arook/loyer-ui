'use strict'

angular.module('loyerApp')
  .service 'Store', ($resource) ->
    # AngularJS will instantiate a singleton by calling "new" on this function

    config =
        base_url: ''
        page:
            size: 24

    service =
    	config: config,
    	resource: (module, service, id, actions = {}) ->
    		$resource("#{@config.base_url}/front/:module/:service/:id", {module: module, service: service, id: id}, actions)
