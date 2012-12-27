module BusinessesHelper
  def has_stat_date?(stat_date)
    # 检查年月'yyyy-mm'
    stat_date =~ /\d{4}-(((0[1-9])|(1[0-2])))/
  end

  def total_bonus_year_month(product_stat_result)
    total_bonuses = 0

    product_stat_result.each do |product_stat|
      total_bonuses += ('%0.2f' % product_stat[:bonus]).to_f
    end 
    total_bonuses
  end
end
