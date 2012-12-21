class CreateGroupBuys < ActiveRecord::Migration
  def change
    create_table :group_buys do |t|
      t.string :product_name
      t.string :settle_type
      t.integer :settle_nums
      t.decimal :settle_money, :precision=>12, :scale => 2
      t.integer :refund_nums
      t.string :state

      t.timestamps
    end
  end
end