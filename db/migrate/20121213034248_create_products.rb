class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :foreign_product_id
      t.string :busi_type
      t.string :platform
      t.float :selled_price
      t.float :settle_price
      t.boolean :is_prepay
      t.float :prepay_percentage
      t.datetime :begin_date
      t.datetime :end_date
      t.integer :selled_nums

      t.timestamps
    end
  end
end
