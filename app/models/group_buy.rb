# encoding: utf-8
class GroupBuy < ActiveRecord::Base
  attr_accessible :product_name, :refund_nums, :settle_type, :settle_money,
                  :settle_nums, :state, :dsr, :real_settle_money, :stat_op_date, :stat_date

  belongs_to :product, :foreign_key => :product_name, :primary_key => :name

  validates_presence_of :settle_nums, :stat_date
  validates_format_of :stat_date, with: /\d{4}-(((0[1-9])|(1[0-2])))/

  scope :month_stat, ->(stat_date) { where(:stat_date => stat_date) }
  scope :settled, -> { where(settle_type: "结算", state: '已处理') }
  scope :with_product_index, -> { where("real_settle_money > 0 and state = '已处理'").order("stat_op_date") }

  before_validation :make_settle_type
  before_save :make_money
  before_create :set_stat_op_date

  def dsr_rate
    # dsr_date为空或者0时，标示用户没有评价，则统计业务员业绩时按100%计算
    if dsr.blank? || dsr == 0.0
      1
    elsif dsr > 0.0 && dsr < 4.0
      0
    elsif dsr >= 4.0 && dsr < 4.3
      0.5
    elsif dsr >= 4.3 && dsr < 4.5
      0.8
    else
      1
    end
  end

  def product_index
    record_index = nil
    product.group_buys.with_product_index.each_with_index do |group, index|
      record_index = index + 1 if group.id == self.id
    end
    record_index
  end

  protected
  def validate
    errors.add(:settle_nums, "必须大于0") if settle_nums <= 0
  end

  private
  def set_stat_op_date
    self.stat_op_date = Time.now
  end

  def get_prepay_money(group_buys)
    prepay_records = group_buys.select { |g| g['settle_type'] == '预付'}

    prepay_money = if !prepay_records.nil? && prepay_records.length > 0
      prepay_records[0]['settle_money']
    else
      0
    end
  end

  def get_already_settled_money(group_buys)
    settle_group_buys = group_buys.select { |g| g['settle_type'] == '结算' && self.id != g.id }
    already_settled_money = 0
    settle_group_buys.each { |g| already_settled_money += g[:settle_money] }
    already_settled_money
  end

  def make_settle_type
    product = self.product
    if self.settle_type == "预付" || product.is_prepay_settlement?
      self.settle_type = "预付"
      self.settle_nums = product.selled_nums
    else
      self.settle_type = "结算"
    end 
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
    # 结算类型，本次操作为结算
    else
      self.settle_money = self.settle_nums * product['settle_price']
      self.real_settle_money = self.settle_money
    end
  end
end
