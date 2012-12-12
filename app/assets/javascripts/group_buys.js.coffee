# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
    'use strict'

    $(".group_buy_table_wrapper #confirm_handle").click (event) ->
        event.preventDefault()
        confirm_checked_groupbuy_records()        

    confirm_checked_groupbuy_records = ->
        id_list = get_checked_groupbuy_id_list()
        id_list_str = JSON.stringify id_list

        $.ajax
            type: 'POST'
            url: '/group_buys/confirm_record'
            beforeSend: (xhr) ->
                xhr.setRequestHeader("Accept", "application/json")
                xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
            data: {"groupbuy_id_list": id_list_str}
            dataType: 'json'
            success: (data) ->
                handled_id_list = data
                local_confirm_record(id_list, handled_id_list)

    local_confirm_record = (local_id_list, handled_id_list) ->
        records = $(".group_buy_table_wrapper table tbody tr")
        for id in handled_id_list
            id_index = local_id_list.indexOf(id)
            if id_index isnt -1
                $(records[id_index]).find(".check_box input[type='checkbox']").attr('checked', false)
                $(records[id_index]).find(".settle_state").text "已处理"


    get_checked_groupbuy_id_list = ->
        id_list = $(".group_buy_table_wrapper table tbody tr").find("td:first input[type='checkbox']:checked").next('input.groupbuy_id').map ->
            parseInt(this.value)

        id_list = id_list.toArray()

