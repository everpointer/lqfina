class Partner < ActiveRecord::Base
  belongs_to :business
  has_many :products

  attr_accessible :bank_acct, :busi_contact_person, :busi_contact_phone, :busi_contact_qq, :business_id, :fina_contact_person, :fina_contact_phone, :has_pay_announce, :is_public_accounting, :name, :openning_bank, :openning_bank_person
end
