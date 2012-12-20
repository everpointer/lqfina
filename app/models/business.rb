class Business < ActiveRecord::Base
  has_many :partners

  attr_accessible :mobile, :nick_name, :qq
end
