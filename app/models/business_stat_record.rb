class BusinessStatRecord < ActiveRecord::Base
  belongs_to :business
  attr_accessible :bonus, :business_id, :stat_date
end
