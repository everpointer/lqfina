# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
    'use strict'

    $("#partner_name.typeahead").typeahead
        source: ->
            partner_collection = JSON.parse($("#partner_collection").val())
            Object.keys(partner_collection)
        updater: (item) ->
            partner_collection = JSON.parse $("#partner_collection").val()
            $("#product_partner_id").val partner_collection[item]
            item

    init = ->
        $('.datepicker').datepicker
            'format': 'yyyy-mm-dd'
            
    init()
