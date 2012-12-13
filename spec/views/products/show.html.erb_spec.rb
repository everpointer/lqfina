require 'spec_helper'

describe "products/show" do
  before(:each) do
    @product = assign(:product, stub_model(Product,
      :name => "Name",
      :foreign_product_id => "Foreign Product",
      :busi_type => "Busi Type",
      :platform => "Platform",
      :selled_price => 1.5,
      :settle_price => 1.5,
      :is_prepay => false,
      :prepay_percentage => 1.5,
      :selled_nums => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Foreign Product/)
    rendered.should match(/Busi Type/)
    rendered.should match(/Platform/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/false/)
    rendered.should match(/1.5/)
    rendered.should match(/1/)
  end
end
