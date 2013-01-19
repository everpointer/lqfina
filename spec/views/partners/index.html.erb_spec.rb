require 'spec_helper'

describe "partners/index" do
  before(:each) do
    @business = assign(:business, stub_model(Business,
      :nick_name => "MyString",
      :mobile => "MyString",
      :qq => "MyString"
    ).as_new_record)

    assign(:partners, [
      stub_model(Partner,
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
        :business_id => @business.id,
        :business => @business
      ),
      stub_model(Partner,
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
        :business_id => @business.id,
        :business => @business
      )
    ])
  end

  it "renders a list of partners" do
    pending
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Busi Contact Person".to_s, :count => 2
    assert_select "tr>td", :text => "Busi Contact Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Busi Contact Qq".to_s, :count => 2
    assert_select "tr>td", :text => "Fina Contact Person".to_s, :count => 2
    assert_select "tr>td", :text => "Fina Contact Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Openning Bank".to_s, :count => 2
    assert_select "tr>td", :text => "Openning Bank Person".to_s, :count => 2
    assert_select "tr>td", :text => "Bank Acct".to_s, :count => 2
    assert_select "tr>td", :text => convert_boolean_cn(false), :count => 4
    assert_select "tr>td", :text => convert_boolean_cn(false), :count => 4
    assert_select "tr>td", :text => @business.nick_name, :count => 2
  end
end
