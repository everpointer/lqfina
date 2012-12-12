# encoding: utf-8
module GroupBuysHelper
  def product_is_prepay?(product_name)
      if !product_name.blank?
        products = Product.where("name = ?", product_name).limit(1)
        if products.length > 0
          return products[0][:is_prepay]
        else
          return nil
        end
      else
        return nil
      end
  end
end
