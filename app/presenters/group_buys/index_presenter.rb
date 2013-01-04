module GroupBuys
  class IndexPresenter
    def initialize(stat_date, product = nil) 
      @stat_date = stat_date
      @product = product
    end

    def get_stat_records(page = 1, nums = nil)
      if @product_name.nil?
        GroupBuy.month_stat(@stat_date).order("product_name, stat_op_date desc").page(page).per(nums)
      else
        @product.group_buys.month_stat(@stat_date).order("product_name, stat_op_date desc").page(page).per(nums)
      end
    end
  end
end