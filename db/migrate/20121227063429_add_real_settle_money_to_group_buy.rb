class AddRealSettleMoneyToGroupBuy < ActiveRecord::Migration
  def change
    add_column :group_buys, :real_settle_money, :decimal, :precision => 12, :scale => 2
  end
end
