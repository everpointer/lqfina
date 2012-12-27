class Business < ActiveRecord::Base
  has_many :partners
  has_many :business_stat_records
  
  attr_accessible :mobile, :nick_name, :qq
end
