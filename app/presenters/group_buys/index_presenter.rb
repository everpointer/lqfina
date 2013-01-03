module GroupBuys
  class IndexPresenter
    def initialize(stat_date, product_name = nil) 
      @stat_date = stat_date
      @product_name = product_name
    end

    def get_stat_records(page = 1, nums = nil)
      if @product_name.blank? || @product_name.empty?
        GroupBuy.month_stat(@stat_date).order("product_name, stat_op_date desc").page(page).per(nums)
      else
        GroupBuy.month_stat(@stat_date).where(product_name: @product_name).order("product_name, stat_op_date desc").page(page).per(nums)
      end
    end
  end
end