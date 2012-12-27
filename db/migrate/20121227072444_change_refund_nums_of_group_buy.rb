# encoding: utf-8
class ChangeRefundNumsOfGroupBuy < ActiveRecord::Migration
  def up
    change_column :group_buys, :product_name, :string, :null => false
    change_column :group_buys, :settle_type, :string, :null => false, :limit => 11
    change_column :group_buys, :settle_nums, :integer, :null => false
    change_column :group_buys, :refund_nums, :integer, :default => 0, :null => false
    change_column :group_buys, :state, :string, :default => '未处理', :null => false, :limit => 11
  end

  def down
    change_column :group_buys, :product_name, :string
    change_column :group_buys, :settle_type, :string
    change_column :group_buys, :settle_nums, :integer
    change_column :group_buys, :refund_nums, :integer
    change_column :group_buys, :state, :string
  end
end
