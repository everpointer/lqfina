class GroupBuy < ActiveRecord::Base
  attr_accessible :product_name, :refund_nums, :settle_type, :settle_money, :settle_nums, :state
end
