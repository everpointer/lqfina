module GroupBuys
  class IndexPresenter
    def initialize(stat_date = nil, product = nil) 
      @stat_date = stat_date
      @product = product
    end

    def get_stat_records(page = 1, nums = nil)
      if @product.nil? && @stat_date.nil?
        GroupBuy.order("stat_op_date desc").page(page).per(nums)
      elsif !@product.nil? && @stat_date.nil?
        @product.group_buys.order("stat_op_date desc").page(page).per(nums)
      elsif !@stat_date.nil? && @product.nil?
        GroupBuy.month_stat(@stat_date).order("stat_op_date desc").page(page).per(nums)
      else
        @product.group_buys.month_stat(@stat_date).order("stat_op_date desc").page(page).per(nums)
      end
    end
  end
end