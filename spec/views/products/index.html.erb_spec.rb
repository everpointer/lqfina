require 'spec_helper'

describe "products/index" do
  before(:each) do
    assign(:products, [
      stub_model(Product,
        :name => "Name",
        :foreign_product_id => "Foreign Product",
        :busi_type => "Busi Type",
        :platform => "Platform",
        :selled_price => 1.5,
        :settle_price => 1.5,
        :is_prepay => false,
        :prepay_percentage => 1.5,
        :selled_nums => 1
      ),
      stub_model(Product,
        :name => "Name",
        :foreign_product_id => "Foreign Product",
        :busi_type => "Busi Type",
        :platform => "Platform",
        :selled_price => 1.5,
        :settle_price => 1.5,
        :is_prepay => false,
        :prepay_percentage => 1.5,
        :selled_nums => 1
      )
    ])
  end

  it "renders a list of products" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Foreign Product".to_s, :count => 2
    assert_select "tr>td", :text => "Busi Type".to_s, :count => 2
    assert_select "tr>td", :text => "Platform".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
