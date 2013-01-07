module ProductsHelper
  def partner_collection(partners)
    collection = {}
    partners.each { |p| collection[p[:name]] = p[:id] }
    collection
  end

  def get_partner_name(product)
    product.partner.name
  end
end
