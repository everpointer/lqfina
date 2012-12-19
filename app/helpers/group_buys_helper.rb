# encoding: utf-8
module GroupBuysHelper
  def is_prepay_settlement?(product_name)
      if !product_name.blank?
        products = Product.find_by_name(product_name)
        is_prepay = true
        if products[:is_prepay]
          products.group_buys.each do |group_buy|
            is_prepay = false if group_buy[:settle_type] == '预付'
          end
        end
        return is_prepay
      else
        return nil
      end
  end
end
