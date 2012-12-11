class GroupBuysController < ApplicationController
    before_filter :init_product_list, :only=>[:index]
    before_filter :init_stat_records, :only=>[:index]

    def index
    end

    def init_product_list
      @total_product_list = Product.all
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
        @group_buys = GroupBuy.where clause
      else
        @group_buys = GroupBuy.all
      end
      # print "length:" + @group_buys.length.to_s
      # @group_buys = GroupBuy.all
    end
end
