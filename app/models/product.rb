# encoding: utf-8
class Product < ActiveRecord::Base
  has_many :group_buys, :foreign_key => 'product_name', :primary_key => :name
  belongs_to :partner

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
                  :settle_price,
                  :partner_id

  validates :name,        :presence   => true
  validates :busi_type,   :presence   => true
  validates :foreign_product_id,  :presence => true
  validates :selled_nums, :presence   => true,
                          :numericality => true
                          
  validates :selled_price, :presence  => true
  validates :settle_price, :presence  => true
  validates :begin_date,     :presence  => true
  validates :end_date,     :presence  => true

  def is_prepay_settlement?
    if self.is_prepay
      is_prepay = true
      self.group_buys.each do |group_buy|
        is_prepay = false if group_buy[:settle_type] == '预付'
      end
    else
      is_prepay = false
    end
    is_prepay
  end
end
