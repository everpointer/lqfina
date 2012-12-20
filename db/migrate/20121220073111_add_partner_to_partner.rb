class AddPartnerToPartner < ActiveRecord::Migration
  def change
    add_column :products, :partner_id, :interger
  end
end
