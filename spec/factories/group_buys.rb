# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :group_buy do
    product_name "测试项目1"
    settle_type "预付"
    settle_nums 100
    settle_money 1000
    refund_nums 10
    state "未处理"
    dsr 4.1
    real_settle_money 0
    stat_date DateTime.now.prev_month.strftime('%Y-%m')
    association :product

    factory :settle_group_buy do
      settle_type "结算"
    end
  end
end
