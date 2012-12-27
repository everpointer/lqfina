class ChangeSettleNumsOfGroupBuy < ActiveRecord::Migration
  def up
    change_column :group_buys, :settle_nums, :integer, :null => false
  end

  def down
    change_column :group_buys, :settle_nums, :string, :null => false
  end
end
