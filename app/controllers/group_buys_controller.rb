class GroupBuysController < ApplicationController
    before_filter :init_stat_records, :only=>[:index]

    def index
    end

    def init_stat_records
        if !params[:stat_date].blank?
            stat_date = Date.parse params[:stat_date] + "-01"
            begin_date = stat_date.beginning_of_month().strftime("%Y-%m-%d")
            end_date = stat_date.end_of_month().strftime("%Y-%m-%d")
            @group_buys = GroupBuy.where(:updated_at => begin_date..end_date)
        else
            @group_buys = GroupBuy.all
        end
    end
end
