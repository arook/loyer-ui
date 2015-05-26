'use strict'

angular.module('loyerApp')
.service 'Cart', ($parse, Store) ->
	# AngularJS will instantiate a singleton by calling "new" on this function
	invoice = {
		items: []

		load: ->
			Store.resource('security', 'order').query {type: 'init'}, (rtn) =>
				items = []
				angular.forEach rtn, (item) ->
					items.push {
						gid: item.gid 
						color: item.color 
						size: item.size 
						qty: item.qty 
						price: item.price
						from: item.of
						cid: item.cid
						eid: item.eid
					}
				this.setItems items

		setItems: (items) ->
			this.items = items
			localStorage.setItem 'cart', JSON.stringify(items)


		save: ->
			localStorage.setItem 'cart', JSON.stringify(this.items)
			Store.resource('security', 'order').save {cart: this.items}, (rtn) ->
				console.debug 'saved' , rtn

		submit: ->
			Store.resource('security', 'submit', null, {submit: {method: 'GET'}}).submit (rtn) ->
				console.debug 'submitted', rtn

		summary: ->
			Store.resource('security', 'order').query {type: 'sumarry'}, (rtn) ->
				rtn.$sum = (el) ->
					total = 0
					angular.forEach rtn, (item) ->
						total += parseInt($parse(el)(item))
					total
				rtn

		top: ->
			Store.resource('security', 'order').query {type: 'top'}, (rtn) ->
				rtn.$sum = (el) ->
					total = 0
					angular.forEach rtn, (item) ->
						total += parseInt($parse(el)(item))
					total
				rtn

		tops: (t = 'category') ->
			Store.resource('security', 'order').query {type: 'tops', group: t}, (rtn) ->
				rtn.$sum = (el) ->
					total = 0
					angular.forEach rtn, (item) ->
						total += parseInt($parse(el)(item))
					total
				rtn

		detail: ->
			Store.resource('security', 'order').query {type: 'detail'}, (rtn) ->
				rtn.$sum = (el) ->
					total = 0
					angular.forEach rtn, (item) ->
						total += parseInt($parse(el)(item))
					total
				rtn.$size = (sn) ->
					total = 0
					angular.forEach rtn, (item) ->
						angular.forEach item.colors, (color) ->
							angular.forEach color.sizes, (qty, sname) ->
								if sname == sn
									total += parseInt(qty)
					total
				rtn
	}


	service = {
		init: ->
			invoice.load()

		submit: ->
			invoice.submit()

		addItem: (gid, color, size, price, qty, cid = 0, eid = 0, from = 'direct') ->
			found = false
			angular.forEach invoice.items, (item, index) ->
				if parseInt(item.gid) == parseInt(gid) and item.color == color and item.size == size and item.cid == cid and item.eid == eid and item.from == from
					invoice.items.splice(index, 1)

			invoice.items.push {
				gid: gid
				color: color
				size: size
				qty: qty
				price: price
				cid: cid
				eid: eid
				from: from
			}

		save: ->
			invoice.save()

		empty: ->
			invoice.items = []
			invoice.save()

		getItem: (gid) ->
			items = []
			angular.forEach invoice.items, (item) ->
				if parseInt(item.gid) == parseInt(gid) and item.from == 'direct'
					items.push item
			items

		getCollection: (gid, cid) ->
			items  = []
			angular.forEach invoice.items, (item) ->
				if parseInt(item.gid) == parseInt(gid) and parseInt(item.cid) == parseInt(cid) and item.from == 'collection'
					items.push item
			items

		getExhibit: (gid, eid) ->
			items  = []
			angular.forEach invoice.items, (item) ->
				if parseInt(item.gid) == parseInt(gid) and parseInt(item.eid) == parseInt(eid) and item.from == 'exhibit'
					items.push item
			items
				

		getItems: ->
			invoice.items		

		removeItem: (index) ->
			invoice.items.splice index, 1
			invoice.save()

		amount: ->
			total = 0
			angular.forEach invoice.items, (item) ->
				total += item.qty * item.price
			total

		total: ->
			total = 0
			angular.forEach invoice.items, (item) ->
				total += item.qty
			total

		# ordered direct count
		oc: (gid) ->
			total = 0
			angular.forEach invoice.items, (item) ->
				if parseInt(item.gid) == parseInt(gid) and item.from == 'direct'
					total += item.qty
			total

		cc: (cid) ->
			t = 0
			angular.forEach invoice.items, (item) ->
				if parseInt(item.cid) == parseInt(cid) and item.from == 'collection'
					t += item.qty
			t

		ec: (eid) ->
			t = 0
			angular.forEach invoice.items, (item) ->
				if parseInt(item.eid) == parseInt(eid) and item.from == 'exhibit'
					t += item.qty
			t
				
		getItemIds: ->
			ids = []
			angular.forEach invoice.items, (item) ->
				ids.push item.gid
			ids.filter (el, pos) -> ids.indexOf el == pos
			ids

		summary: ->
			invoice.summary()

		top: ->
			invoice.top()

		tops: (t) ->
			invoice.tops(t)

		detail: ->
			invoice.detail()
	}
