class ChangeSettleMoneyOfGroupbuy < ActiveRecord::Migration
  def up
    change_column :group_buys, :settle_money, :deciaml, :precision=>12, :scale => 2
  end

  def down
    change_column :group_buys, :settle_money, :float
  end
end
