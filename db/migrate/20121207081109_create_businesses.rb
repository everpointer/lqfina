class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
        t.string :busi_type
        t.string :name

        t.timestamps
    end
  end
end
