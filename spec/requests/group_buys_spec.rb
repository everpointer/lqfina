# encoding: utf-8
require 'spec_helper'

describe "GroupBuys" do
  describe "GET /group_buys" do
    it "sees current month's settle record" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      GroupBuy.create :product_name => "测试项目", :settle_type => "预付", :settle_nums => 100, :settle_money => 1000, :refund_nums => 10, :state => "未处理"

      visit group_buys_path

      current_path.should == group_buys_path


      within "#group_buy_record_table" do
        find("tr:first").should have_content "测试项目"
      end

    end
  end
end
