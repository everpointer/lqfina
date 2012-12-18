class Product < ActiveRecord::Base
  attr_accessible :begin_date,
                  :busi_type,
                  :end_date,
                  :foreign_product_id,
                  :is_prepay,
                  :name,
                  :busi_type,
                  :platform,
                  :prepay_percentage,
                  :selled_nums,
                  :selled_price,
                  :settle_price

  validates :name,        :presence   => true
  validates :busi_type,   :presence   => true
  validates :foreign_product_id,  :presence => true
  validates :selled_nums, :presence   => true,
                          :numericality => true
                          
  validates :selled_price, :presence  => true
  validates :settle_price, :presence  => true
  validates :begin_date,     :presence  => true
  validates :end_date,     :presence  => true

end
