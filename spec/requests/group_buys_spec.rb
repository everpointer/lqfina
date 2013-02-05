# encoding: utf-8
require 'spec_helper'

def search_a_product(product_name)
  within "#stat_action_bar" do
    fill_in "stat_date",  :with => DateTime.now.prev_month.strftime('%Y-%m')
    fill_in "product_name_list", :with => product_name
  end 
  first(".typeahead.dropdown-menu > li").click
  click_button '查询'
end

describe "GroupBuys" do
  describe "GET /group_buys", js: true do
    let!(:business1) { FactoryGirl.create(:business) }
    let!(:partner1) { FactoryGirl.create(:partner, business: business1) }
    let!(:product1) { FactoryGirl.create(:product, partner: partner1) }
    let!(:product2) { FactoryGirl.create(:unprepay_product, partner: partner1) }

    it "sees current month's settle record" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      # @groupbuy1 = GroupBuy.create :product_name => "测试项目1", :settle_type => "预付", :settle_nums => 100, :settle_money => 1000, :refund_nums => 10, :state => "未处理", :dsr => 4.1, :real_settle_money => 0, :stat_date => DateTime.now.prev_month.strftime('%Y-%m')
      @groupbuy1 = FactoryGirl.create(:group_buy, product: product1)

      visit group_buys_path

      search_a_product product1.name

      current_path.should == group_buys_path

      within "#group_buy_record_table" do
        all("tbody tr").length.should == 1
      end
    end

    it "adds a product's prepay record" do
      visit group_buys_path

      search_a_product product1.name

      current_path.should == group_buys_path

      within "#new_group_buy" do
        # fill_in 'group_buy_settle_nums', :with => @product1.selled_nums
        click_button "新增"
      end
      current_path.should == group_buys_path

      within "#group_buy_record_table" do
        all("tbody tr").length.should > 0
        all("tbody tr")[0].find(".product_name").text.should == product1.name
        all("tbody tr")[0].find(".settle_nums").text.should == product1.selled_nums.to_s

        settle_money = product1.prepay_percentage * product1.selled_nums * product1.settle_price
        all("tbody tr")[0].find(".settle_money").text.should == '%0.2f' % settle_money
      end
    end

    it "adds a product's settle record" do
      visit group_buys_path

      search_a_product product2.name

      current_path.should == group_buys_path
      within "#new_group_buy" do
        fill_in 'group_buy_settle_nums', :with => 1001
        fill_in 'group_buy_refund_nums', :with => 100

        click_button "新增"
      end
      current_path.should == group_buys_path

      within "#group_buy_record_table" do
        all("tbody tr").length.should > 0
        all("tbody tr")[0].find(".product_name").text.should == product2.name
        all("tbody tr")[0].find(".settle_nums").text.should == "1001"
        all("tbody tr")[0].find(".refund_nums").text.should == "100"

        settle_money = product2.settle_price * 1001
        all("tbody tr")[0].find(".settle_money").text.should == '%0.2f' % settle_money
      end
    end

    it 'confirms handlement of checked groupbuy records', :js => true do
      # @groupbuy1 = GroupBuy.create :product_name => "测试项目1", :settle_type => "预付", :settle_nums => 100, :settle_money => 1000, :refund_nums => 10, :state => "未处理", :dsr => 4.1, :real_settle_money => 0, :stat_date => DateTime.now.prev_month.strftime('%Y-%m')
      @groupbuy1 = FactoryGirl.create(:group_buy, product: product1)
      visit group_buys_path

      search_a_product product1.name

      current_path.should == group_buys_path

      within ".group_buy_table_wrapper" do
        find("tbody tr:first td input[type='checkbox']").set true
        
        find("#confirm_handle").click
        
        current_path.should == group_buys_path
        find("tbody tr:first td.settle_state").text.should == "已处理"

        find("tbody tr:first td input[type='checkbox']").set true
        find("#cancel_handle").click
        current_path.should == group_buys_path
        find("tbody tr:first td.settle_state").text.should == "未处理"
      end
    end
  end
end
