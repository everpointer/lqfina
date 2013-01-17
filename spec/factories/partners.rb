# encoding: utf-8
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :partner do
    busi_contact_person "MyString"
    busi_contact_phone "MyString"
    busi_contact_qq "MyString"
    fina_contact_person "MyString"
    fina_contact_phone "MyString"
    openning_bank "MyString"
    openning_bank_person "MyString"
    bank_acct "MyString"
    is_public_accounting false
    has_pay_announce false
    association :business
  end
end
