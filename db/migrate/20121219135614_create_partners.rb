class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.string :busi_contact_person
      t.string :busi_contact_phone
      t.string :busi_contact_qq
      t.string :fina_contact_person
      t.string :fina_contact_phone
      t.string :openning_bank
      t.string :openning_bank_person
      t.string :bank_acct
      t.boolean :is_public_accounting
      t.boolean :has_pay_announce
      t.integer :business_id

      t.timestamps
    end
  end
end
