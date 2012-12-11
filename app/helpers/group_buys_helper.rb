module GroupBuysHelper
  def product_is_prepay?(product_name)
      if !product_name.blank?
        product = Product.where("name = ?", params[:product_name])
        if !product
          return product[:is_prepay]
        else
          return nil
        end
      else
        return nil
      end
  end
end
