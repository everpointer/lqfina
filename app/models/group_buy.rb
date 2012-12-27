class GroupBuy < ActiveRecord::Base
  belongs_to :product, :foreign_key => :product_name, :primary_key => :name
  
  attr_accessible :product_name, :refund_nums, :settle_type, :settle_money, :settle_nums, :state, :dsr, :real_settle_money
end
