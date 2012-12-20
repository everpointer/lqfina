require 'spec_helper'

describe "partners/show" do
  before(:each) do
    @partner = assign(:partner, stub_model(Partner,
      :name => "Name",
      :busi_contact_person => "Busi Contact Person",
      :busi_contact_phone => "Busi Contact Phone",
      :busi_contact_qq => "Busi Contact Qq",
      :fina_contact_person => "Fina Contact Person",
      :fina_contact_phone => "Fina Contact Phone",
      :openning_bank => "Openning Bank",
      :openning_bank_person => "Openning Bank Person",
      :bank_acct => "Bank Acct",
      :is_public_accounting => false,
      :has_pay_announce => false,
      :business_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Busi Contact Person/)
    rendered.should match(/Busi Contact Phone/)
    rendered.should match(/Busi Contact Qq/)
    rendered.should match(/Fina Contact Person/)
    rendered.should match(/Fina Contact Phone/)
    rendered.should match(/Openning Bank/)
    rendered.should match(/Openning Bank Person/)
    rendered.should match(/Bank Acct/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/1/)
  end
end
