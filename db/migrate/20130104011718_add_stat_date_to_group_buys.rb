class AddStatDateToGroupBuys < ActiveRecord::Migration
  def change
    add_column :group_buys, :stat_date, :string, :limit => 20
  end
end
