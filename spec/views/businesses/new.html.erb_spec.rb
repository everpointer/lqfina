require 'spec_helper'

describe "businesses/new" do
  before(:each) do
    assign(:business, stub_model(Business,
      :nick_name => "MyString",
      :mobile => "MyString",
      :qq => "MyString"
    ).as_new_record)
  end

  it "renders new business form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => businesses_path, :method => "post" do
      assert_select "input#business_nick_name", :name => "business[nick_name]"
      assert_select "input#business_mobile", :name => "business[mobile]"
      assert_select "input#business_qq", :name => "business[qq]"
    end
  end
end
