# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :business do
    nick_name "MyString"
    mobile "MyString"
    qq "MyString"
    association :partner
  end
end
