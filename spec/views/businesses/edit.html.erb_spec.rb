require 'spec_helper'

describe "businesses/edit" do
  before(:each) do
    @business = assign(:business, stub_model(Business,
      :nick_name => "MyString",
      :mobile => "MyString",
      :qq => "MyString"
    ))
  end

  it "renders the edit business form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => businesses_path(@business), :method => "post" do
      assert_select "input#business_nick_name", :name => "business[nick_name]"
      assert_select "input#business_mobile", :name => "business[mobile]"
      assert_select "input#business_qq", :name => "business[qq]"
    end
  end
end
