class ChangePartnerIdOfProduct < ActiveRecord::Migration
  def up
    change_column :products, :partner_id, :interger, :null => false
  end

  def down
    change_column :products, :partner_id, :interger
  end
end
