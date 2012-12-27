class AddDsrToGroupBuy < ActiveRecord::Migration
  def change
    add_column :group_buys, :dsr, :float
  end
end
