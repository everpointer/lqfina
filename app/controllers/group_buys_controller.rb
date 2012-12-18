# encoding: utf-8
class GroupBuysController < ApplicationController
    before_filter :init_variable, :only=>[:index]
    before_filter :init_product_list, :only=>[:index]
    before_filter :init_record_add_form, :only=>[:index]
    before_filter :init_stat_records, :only=>[:index]

    def index
    end

    def create
      groupbuy = {}
      groupbuy['product_name'] = params[:product_name]
      product = Product.find_by_name(groupbuy['product_name'])


      if params[:is_prepay] == "true"
        groupbuy['settle_type'] = "预付"
        groupbuy['settle_nums'] = product['selled_nums'] 
        groupbuy['settle_money'] = product['prepay_percentage'] * product['selled_nums'] * product['settle_price']
      else
        groupbuy['settle_type'] = "结算"
        groupbuy['refund_nums'] = params[:group_buy][:refund_nums].to_i
        groupbuy['settle_nums'] = params[:group_buy][:settle_nums].to_i
        groupbuy['settle_money'] = groupbuy['settle_nums'] * product['settle_price']
      end
      groupbuy['state'] = "未处理"

      GroupBuy.create groupbuy

      # redirect_to group_buys_path + "?product_name=#{params[:product_name]}&stat_date=#{params[:stat_date]}"
      redirect_to :back
    end

    def confirm_record
      groupbuy_id_list = JSON.parse(params[:groupbuy_id_list])
      confirm_flag =  params[:confirm_flag]

      if confirm_flag == "true"
        settle_state = "已处理"
      else
        settle_state = "未处理"
      end

      if !groupbuy_id_list.blank?
        hanlded_id_list = []
        result = GroupBuy.find(groupbuy_id_list).each do |group_buy|
          group_buy.state = settle_state
          group_buy.save
          hanlded_id_list << group_buy.id
        end
        respond_to do |format|
          format.html do
            redirect_to :back 
          end
          format.json { render :json => hanlded_id_list.as_json }
          format.js { render :nothing => true }
        end
      else
       redirect_to :back 
      end
    end

    def init_variable
      if params[:stat_date].blank?
        @current_year_month = DateTime.now.strftime('%Y-%m')
      else
        @current_year_month = params[:stat_date]
      end
    end

    def init_product_list
      @total_product_list = Product.all
    end

    def init_record_add_form
      @group_buy = GroupBuy.new
    end

    def product_is_prepay?(product_name)
      if !product_name.blank?
        product = Product.where("name = ?", product_name).find(1)
        if product[:is_prepay]
          return true
        else
          return false
        end
      else
        return nil
      end
    end

    def init_stat_records
      clause = {}
      # if !params[:stat_date].blank?
        # Date can't parse 'yyyy-mm' format
      stat_date = Date.parse @current_year_month + "-01"

      begin_date = stat_date.beginning_of_month().strftime("%Y-%m-%d")
      end_date = stat_date.end_of_month().strftime("%Y-%m-%d")
      clause[:updated_at] = begin_date..end_date
      # end
      if !params[:product_name].blank?
        clause[:product_name] = params[:product_name]
      end

      if !clause.blank?
        @group_buys = GroupBuy.where(clause).order("product_name, updated_at desc")
      else
        @group_buys = GroupBuy.order("product_name, updated_at desc").all
      end
    end
end
