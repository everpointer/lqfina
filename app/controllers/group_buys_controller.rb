# encoding: utf-8
class GroupBuysController < ApplicationController
    before_filter :init_product_list, :only=>[:index]
    before_filter :init_record_add_form, :only=>[:index]
    before_filter :init_stat_records, :only=>[:index]

    def index
    end

    def create
      groupbuy = {}
      groupbuy['product_name'] = params[:product_name]
      if params[:is_prepay] == "true"
        print "in true"
        groupbuy['settle_type'] = "预付"
        groupbuy['settle_nums'] = params[:group_buy][:settle_nums]
      else
        groupbuy['settle_type'] = "结算"
        groupbuy['refund_nums'] = params[:group_buy][:refund_nums]
      end
      groupbuy['settle_nums'] = params[:group_buy][:settle_nums]
      groupbuy['state'] = "未处理"

      GroupBuy.create groupbuy

      # redirect_to group_buys_path + "?product_name=#{params[:product_name]}&stat_date=#{params[:stat_date]}"
      redirect_to :back
    end

    def confirm_record
      groupbuy_id_list = JSON.parse(params[:groupbuy_id_list])
      print groupbuy_id_list

      if !groupbuy_id_list.blank?
        hanlded_id_list = []
        result = GroupBuy.find(groupbuy_id_list).each do |group_buy|
          group_buy.state = "已处理"
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
      if !params[:stat_date].blank?
        # Date can't parse 'yyyy-mm' format
        stat_date = Date.parse params[:stat_date] + "-01"

        begin_date = stat_date.beginning_of_month().strftime("%Y-%m-%d")
        end_date = stat_date.end_of_month().strftime("%Y-%m-%d")
        clause[:updated_at] = begin_date..end_date
      end
      if !params[:product_name].blank?
        clause[:product_name] = params[:product_name]
      end

      if !clause.blank?
        @group_buys = GroupBuy.where(clause).order("updated_at desc")
      else
        @group_buys = GroupBuy.order("updated_at desc").all
      end
      # print "length:" + @group_buys.length.to_s
      # @group_buys = GroupBuy.all
    end
end
