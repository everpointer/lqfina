class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :nick_name
      t.string :mobile
      t.string :qq

      t.timestamps
    end
  end
end
