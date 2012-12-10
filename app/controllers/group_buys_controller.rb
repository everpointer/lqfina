class GroupBuysController < ApplicationController
    before_filter :init, :only=>[:index]

    def index
    end

    def init
        @group_buys = GroupBuy.all
    end
end
