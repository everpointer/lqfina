# encoding: utf-8
module GroupBuysHelper
  def is_prepay_settlement?(product_name)
      if !product_name.blank?
        products = Product.find_by_name(product_name)
        if products[:is_prepay]
          is_prepay = true
          products.group_buys.each do |group_buy|
            is_prepay = false if group_buy[:settle_type] == '预付'
          end
        else
          is_prepay = false
        end
        return is_prepay
      else
        return nil
      end
  end
end
