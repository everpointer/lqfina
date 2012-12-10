class CreateGroupBuys < ActiveRecord::Migration
  def change
    create_table :group_buys do |t|
      t.string :product_name
      t.string :settle_type
      t.integer :settle_nums
      t.float :settle_money
      t.integer :refund_nums
      t.string :state

      t.timestamps
    end
  end
end
