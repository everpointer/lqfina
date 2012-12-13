require 'spec_helper'

describe "products/edit" do
  before(:each) do
    @product = assign(:product, stub_model(Product,
      :name => "MyString",
      :foreign_product_id => "MyString",
      :busi_type => "MyString",
      :platform => "MyString",
      :selled_price => 1.5,
      :settle_price => 1.5,
      :is_prepay => false,
      :prepay_percentage => 1.5,
      :selled_nums => 1
    ))
  end

  it "renders the edit product form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => products_path(@product), :method => "post" do
      assert_select "input#product_name", :name => "product[name]"
      assert_select "input#product_foreign_product_id", :name => "product[foreign_product_id]"
      assert_select "input#product_busi_type", :name => "product[busi_type]"
      assert_select "input#product_platform", :name => "product[platform]"
      assert_select "input#product_selled_price", :name => "product[selled_price]"
      assert_select "input#product_settle_price", :name => "product[settle_price]"
      assert_select "input#product_is_prepay", :name => "product[is_prepay]"
      assert_select "input#product_prepay_percentage", :name => "product[prepay_percentage]"
      assert_select "input#product_selled_nums", :name => "product[selled_nums]"
    end
  end
end
