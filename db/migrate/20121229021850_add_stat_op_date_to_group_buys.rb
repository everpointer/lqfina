class AddStatOpDateToGroupBuys < ActiveRecord::Migration
  def change
    add_column :group_buys, :stat_op_date, :datetime
  end
end
