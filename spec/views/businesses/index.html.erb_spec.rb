require 'spec_helper'

describe "businesses/index" do
  before(:each) do
    assign(:businesses, [
      stub_model(Business,
        :nick_name => "Nick Name",
        :mobile => "Mobile",
        :qq => "Qq"
      ),
      stub_model(Business,
        :nick_name => "Nick Name",
        :mobile => "Mobile",
        :qq => "Qq"
      )
    ])
  end

  it "renders a list of businesses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Nick Name".to_s, :count => 2
    assert_select "tr>td", :text => "Mobile".to_s, :count => 2
    assert_select "tr>td", :text => "Qq".to_s, :count => 2
  end
end
