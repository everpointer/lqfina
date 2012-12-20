require 'spec_helper'

describe "businesses/show" do
  before(:each) do
    @business = assign(:business, stub_model(Business,
      :nick_name => "Nick Name",
      :mobile => "Mobile",
      :qq => "Qq"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Nick Name/)
    rendered.should match(/Mobile/)
    rendered.should match(/Qq/)
  end
end
