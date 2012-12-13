class Product < ActiveRecord::Base
  attr_accessible :begin_date, :busi_type, :end_date, :foreign_product_id, :is_prepay, :name, :platform, :prepay_percentage, :selled_nums, :selled_price, :settle_price
end
