'use strict'

angular.module('loyerApp')
.service 'Repl', ($parse, Store) ->
    # AngularJS will instantiate a singleton by calling "new" on this function
    invoice = {
        items: []

        load: ->
            Store.resource('security', 'repl').query {type: 'init'}, (rtn) =>
                items = []
                angular.forEach rtn, (item) ->
                    items.push {
                        gid: item.gid
                        color: item.color
                        size: item.size
                        qty: item.qty
                        price: item.price
                    }
                this.setItems items

        setItems: (items) ->
            this.items = items
            localStorage.setItem 'repl', JSON.stringify(items)

        save: ->
            localStorage.setItem 'repl', JSON.stringify(this.items)
            Store.resource('security', 'repl').save {cart: this.items}, (rtn) ->
                console.debug 'saved', rtn

        submit: ->
            Store.resource('security', 'submit', null, {submit: {method: 'GET'}}).submit {type: 'replenish'}, (rtn) ->
                console.debug 'submitted', rtn

        summary: ->
            Store.resource('security', 'repl').query {type: 'sumarry'}, (rtn) ->
                rtn.$sum = (el) ->
                    total = 0
                    angular.forEach rtn, (item) ->
                        total += parseInt($parse(el)(item))
                    total
                rtn

        tops: (t = 'category') ->
            Store.resource('security', 'repl').query {type: 'tops', group: t}, (rtn) ->
                rtn.$sum = (el) ->
                    total = 0
                    angular.forEach rtn, (item) ->
                        total += parseInt($parse(el)(item))
                    total
                rtn

        detail: ->
            Store.resource('security', 'repl').query {type: 'detail'}, (rtn) ->
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

        addItem: (gid, color, size, price, qty) ->
            angular.forEach invoice.items, (item, index) ->
                if parseInt(item.gid) == parseInt(gid) and item.color == color and item.size == size
                    invoice.items.splice(index)

            invoice.items.push {
                gid: gid
                color: color
                size: size
                qty: qty
                price: price
            }

        save: ->
            invoice.save()

        empty: ->
            invoice.items = []
            invoice.save()

        getItem: (gid) ->
            items = []
            angular.forEach invoice.items, (item) ->
                if parseInt(item.gid) == parseInt(gid)
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

        oc: (gid) ->
            total = 0
            angular.forEach invoice.items, (item) ->
                if parseInt(item.gid) == parseInt(gid)
                    total += item.qty
            total

        summary: ->
            invoice.summary()

        tops: (t) ->
            invoice.tops(t)

        detail: ->
            invoice.detail()
    }
