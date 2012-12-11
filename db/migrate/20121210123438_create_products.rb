class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.datetime :online_date

      t.timestamps
    end
  end
end
