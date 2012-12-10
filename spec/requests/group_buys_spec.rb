# encoding: utf-8
require 'spec_helper'

describe "GroupBuys" do
  describe "GET /group_buys" do
    it "sees current month's settle record" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      GroupBuy.create :product_name => "测试项目1", :settle_type => "预付", :settle_nums => 100, :settle_money => 1000, :refund_nums => 10, :state => "未处理"
      GroupBuy.create :product_name => "测试项目2", :settle_type => "结算", :settle_nums => 100, :settle_money => 1000, :refund_nums => 10, :state => "未处理"

      visit group_buys_path

      within "#stat_action_bar" do
        fill_in "stat_date",  :with => DateTime.now.strftime('%Y-%m')
        click_button '查询'
      end

      # post group_buys_path, :stat_date => "2012-12"
      current_path.should == group_buys_path

      within "#group_buy_record_table" do
        find("tr:first").should have_content "测试项目1"
      end

    end
  end
end
