class Product < ActiveRecord::Base
  attr_accessible :name, :online_date, :is_prepay, :type, :selled_nums, :settle_nums, :refund_nums, :settle_money, :state
end
