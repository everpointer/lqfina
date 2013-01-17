# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    sequence(:name) { |i| "测试项目#{i}" }
    foreign_product_id  '1'
    busi_type  "团购"
    platform  "聚划算"
    selled_price  100
    settle_price  50
    is_prepay  true
    prepay_percentage  0.5
    begin_date  Date.today.prev_month
    end_date  Date.today.next_month
    selled_nums  100
    association :partner
  end
end
