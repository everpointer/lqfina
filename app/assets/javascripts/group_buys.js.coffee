# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
    'use strict'

    $(".group_buy_table_wrapper #confirm_handle").click (event) ->
        event.preventDefault()
        confirm_checked_groupbuy_records(true)        

    $(".group_buy_table_wrapper #cancel_handle").click (event) ->
        event.preventDefault()
        confirm_checked_groupbuy_records(false)

    $(".group_buy_table_wrapper #export_finance_output_list").click (event) ->
        event.preventDefault()
        export_checked_finance_records()

    $(".group_buy_table_wrapper #edit_record").click (event) ->
        event.preventDefault()
        edit_checked_one_record()

    $("#group_buy_record_table input[type='checkbox']").click (event) ->
        event.stopPropagation()

    $("#group_buy_record_table > tbody > tr.group_buy").each (index, item) ->
        item.onclick = ->
            checkbox = $(this).find("td.check_box input[type='checkbox']")
            checked = checkbox.attr('checked') 
            checked = false if checked is undefined
            checkbox.attr('checked', !checked)
            return false

    # $('.datepicker').datepicker
        # "format" : 'yyyy-mm-dd'

    # set typeahead for group_buy product_name input
    $("#product_name_list.typeahead").typeahead
        source: ->
            partner_collection = JSON.parse($("#product_collection").attr("value"))
            # Object.keys(partner_collection)
        updater: (item) ->
            # partner_collection = JSON.parse $("#partner_collection").val()
            $("#product_name").val item.split("{")[0]
            item

    # $("#group_buy_table_wrapper tbody tr.group_buy").click (event) ->
    #     event.preventDefault()
    #     todo: support specifed group_buy record change

    # confirm_flag: boolean true means confirm, false means unconfirm
    confirm_checked_groupbuy_records = (confirm_flag) ->
        id_list = get_checked_groupbuy_id_list()
        id_list_str = JSON.stringify id_list

        $.ajax
            type: 'post'
            url: '/group_buys/confirm_record'
            data: {"groupbuy_id_list": id_list_str, "confirm_flag":confirm_flag, "_method":"put"}
            dataType: 'json'
            success: (data) ->
                handled_id_list = data
                local_id_list = get_local_groupbuy_id_list()
                local_confirm_record(local_id_list, handled_id_list, confirm_flag)

    export_checked_finance_records = ->
        if check_export_operation() is false
            alert("导出结果中有未处理记录,请先处理掉")
            return false
        id_list = get_checked_groupbuy_id_list()
        window.location = "group_buys/export_finance_records?id_list=" + id_list.join(',')

    edit_checked_one_record = ->
        checked_records = get_checked_groupbuy_record()
        # id_list = get_checked_groupbuy_id_list()
        if checked_records.length isnt 1
            alert('请选中1条记录进行修改')
        else
            window.location = 
                window.location.origin+ "/group_buys/" + checked_records[0].id


    local_confirm_record = (local_id_list, handled_id_list, confirm_flag) ->
        if confirm_flag is true
            settle_state = "已处理"
        else
            settle_state = "未处理"

        records = $(".group_buy_table_wrapper table tbody tr")
        # for (i = 0; i < handled_id_list.length; i++)
        for id in handled_id_list
            id_index = local_id_list.indexOf(id)
            if id_index isnt -1
                $(records[id_index]).find(".check_box input[type='checkbox']").attr('checked', false)
                $(records[id_index]).find(".settle_state").text settle_state


    get_checked_groupbuy_record = ->
        checked_id_list = $(".group_buy_table_wrapper table tbody tr td.check_box input[type='checkbox']:checked").parents('tr').map(->
            id = $(this).find("td.check_box input[type='checkbox']:checked").next('input.groupbuy_id').val()
            product_name = $(this).find("td.product_name").text()
            stat_date = $(this).find("td.update_date").text().substr(0,7)
            settle_state = $(this).find("td.settle_state").text()
            {"id": id,  "product_name": product_name, "stat_date": stat_date, "settle_state": settle_state }
        ).get()

    get_checked_groupbuy_id_list = ->
        checked_id_list = $(".group_buy_table_wrapper table tbody tr").find("td:first input[type='checkbox']:checked").next('input.groupbuy_id').map ->
            parseInt(this.value)

        checked_id_list = checked_id_list.toArray()

    get_local_groupbuy_id_list = ->
        local_id_list = $(".group_buy_table_wrapper table tbody tr").find("td:first input[type='checkbox']").next('input.groupbuy_id').map ->
            parseInt(this.value)

        local_id_list = local_id_list.toArray()

    check_export_operation = ->
        records = get_checked_groupbuy_record()
        result = true
        for record in records
            result = false if record.settle_state is "未处理"
        result


