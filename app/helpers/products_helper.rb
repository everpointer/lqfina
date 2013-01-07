# encoding: utf-8
module ProductsHelper
  def partner_collection(partners)
    collection = {}
    partners.each { |p| collection[p[:name]] = p[:id] }
    collection
  end

  def get_partner_name(product)
    product.partner.name unless product.partner.nil?
  end

  def tmall_product_link(product_id)
    tmall_link = "http://detail.tmall.com/item.htm?id=#{product_id}"
    link_to("↳", tmall_link, :target=> "_blank") 
  end
end
