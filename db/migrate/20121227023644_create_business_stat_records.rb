class CreateBusinessStatRecords < ActiveRecord::Migration
  def change
    create_table :business_stat_records do |t|
      t.integer :business_id, :null => false
      t.string  :stat_date, :limit => 11, :null => false
      t.decimal :bonus, :scale => 2, :null => false

      t.timestamps
    end
  end
end
