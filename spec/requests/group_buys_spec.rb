# encoding: utf-8
require 'spec_helper'

def search_a_product(product_name)
  within "#stat_action_bar" do
        fill_in "stat_date",  :with => DateTime.now.strftime('%Y-%m')
        select product_name, :from => 'product_list'
        click_button '查询'
  end 
end

describe "GroupBuys" do
  before :each do
    Product.create :name => "测试项目1", :online_date => "2012-12-01 08:00:00", :is_prepay => false
    Product.create :name => "测试项目2", :online_date => "2012-12-01 08:00:00", :is_prepay => true

    GroupBuy.create :product_name => "测试项目1", :settle_type => "预付", :settle_nums => 100, :settle_money => 1000, :refund_nums => 10, :state => "未处理"
    GroupBuy.create :product_name => "测试项目2", :settle_type => "结算", :settle_nums => 100, :settle_money => 1000, :refund_nums => 10, :state => "未处理"
  end


  describe "GET /group_buys" do
    it "sees current month's settle record" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers

      visit group_buys_path

      search_a_product "测试项目1"

      current_path.should == group_buys_path

      within "#group_buy_record_table" do
        # all("tr").should have_content "测试项目1"
        all("tbody tr").length.should == 1
      end
    end

    it "adds a product's prepay record" do
      visit group_buys_path

      search_a_product "测试项目1"

      current_path.should == group_buys_path

      # save_and_open_page
      within "#new_group_buy" do
        fill_in 'group_buy_settle_nums', :with => 1001
        fill_in 'group_buy_refund_nums', :with => 100

        click_button "新增"
      end
      current_path.should == group_buys_path

      within "#group_buy_record_table" do
        all("tbody tr").length.should > 0
        all("tbody tr")[0].find(".product_name").text.should == "测试项目1"
        all("tbody tr")[0].find(".settle_nums").text.should == "1001"
        all("tbody tr")[0].find(".refund_nums").text.should == "100"
      end
    end

    it 'confirms handlement of checked groupbuy records', :js => true do
      visit group_buys_path

      search_a_product "测试项目1"

      current_path.should == group_buys_path

      within ".group_buy_table_wrapper" do
        find("tbody tr:first td input[type='checkbox']").set true
        find("#confirm_handle").click
        current_path.should == group_buys_path
        save_and_open_page
        find("tbody tr:first td.settle_state").text.should == "已处理"

        find("tbody tr:first td input[type='checkbox']").set true
        find("#cancel_handle").click
        current_path.should == group_buys_path
        save_and_open_page
        find("tbody tr:first td.settle_state").text.should == "未处理"
      end
    end
  end
end
