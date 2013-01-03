# encoding: utf-8
class GroupBuy < ActiveRecord::Base
  before_create :set_stat_op_date
  before_save :make_money

  belongs_to :product, :foreign_key => :product_name, :primary_key => :name

  attr_accessible :product_name, :refund_nums, :settle_type, :settle_money, :settle_nums, :state, :dsr, :real_settle_money, :stat_op_date

  validates :settle_nums, :presence  => true

  scope :month_stat, ->(stat_date) { where(:stat_op_date => stat_date.next_month.beginning_of_month().strftime("%Y-%m-%d")..
                                                            stat_date.next_month.end_of_month().strftime("%Y-%m-%d"))
                                   }
  private
  def set_stat_op_date
    self.stat_op_date = Time.now
  end

  def get_prepay_money(group_buys)
    prepay_records = group_buys.select { |g| g['settle_type'] == '预付'}
    prepay_money = prepay_records[0]['settle_money'] || 0
  end

  def get_already_settled_money(group_buys)
    settle_group_buys = group_buys.select { |g| g['settle_type'] == '结算'}
    already_settled_money = 0
    settle_group_buys.each { |g| already_settled_money += g[:settle_money] }
    already_settled_money
  end

  def make_money
    product = self.product
    # 预付类型，本次操作为预付
    if self.settle_type == "预付" 
      self.settle_money = product['prepay_percentage'] * product['selled_nums'] * product['settle_price']
      self.real_settle_money = 0
    # 预付类型，本次操作为结算
    elsif product.is_prepay
      self.settle_money = self.settle_nums * product['settle_price']
      self.real_settle_money = self.settle_money
    # 结算类型，本次操作为结算
    else
      self.settle_money = self.settle_nums * product['settle_price']
      group_buys = product.group_buys
      prepay_money = get_prepay_money(group_buys)
      already_settled_money = get_already_settled_money(group_buys)
      self.real_settle_money = if already_settled_money >= prepay_money
        self.settle_money
      elsif (already_settled_money + self.settle_money) > prepay_money 
        already_settled_money + self.settle_money - prepay_money
      else
        0
      end
    end
  end

end
