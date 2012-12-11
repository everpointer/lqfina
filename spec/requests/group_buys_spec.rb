# encoding: utf-8
require 'spec_helper'

describe "GroupBuys" do
  before :each do
    Product.create :name => "测试项目1", :online_date => "2012-12-01 08:00:00"
  end

  describe "GET /group_buys" do
    it "sees current month's settle record" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      GroupBuy.create :product_name => "测试项目1", :settle_type => "预付", :settle_nums => 100, :settle_money => 1000, :refund_nums => 10, :state => "未处理"
      GroupBuy.create :product_name => "测试项目2", :settle_type => "结算", :settle_nums => 100, :settle_money => 1000, :refund_nums => 10, :state => "未处理"

      visit group_buys_path

      within "#stat_action_bar" do
        fill_in "stat_date",  :with => DateTime.now.strftime('%Y-%m')
        select '测试项目1', :from => 'product_list'
        click_button '查询'
      end

      current_path.should == group_buys_path

      within "#group_buy_record_table" do
        # all("tr").should have_content "测试项目1"
        all("tr").length.should == 1
      end
    end
  end
end
