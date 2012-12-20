require 'spec_helper'

describe "partners/new" do
  before(:each) do
    assign(:partner, stub_model(Partner,
      :name => "MyString",
      :busi_contact_person => "MyString",
      :busi_contact_phone => "MyString",
      :busi_contact_qq => "MyString",
      :fina_contact_person => "MyString",
      :fina_contact_phone => "MyString",
      :openning_bank => "MyString",
      :openning_bank_person => "MyString",
      :bank_acct => "MyString",
      :is_public_accounting => false,
      :has_pay_announce => false,
      :business_id => 1
    ).as_new_record)
  end

  it "renders new partner form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => partners_path, :method => "post" do
      assert_select "input#partner_name", :name => "partner[name]"
      assert_select "input#partner_busi_contact_person", :name => "partner[busi_contact_person]"
      assert_select "input#partner_busi_contact_phone", :name => "partner[busi_contact_phone]"
      assert_select "input#partner_busi_contact_qq", :name => "partner[busi_contact_qq]"
      assert_select "input#partner_fina_contact_person", :name => "partner[fina_contact_person]"
      assert_select "input#partner_fina_contact_phone", :name => "partner[fina_contact_phone]"
      assert_select "input#partner_openning_bank", :name => "partner[openning_bank]"
      assert_select "input#partner_openning_bank_person", :name => "partner[openning_bank_person]"
      assert_select "input#partner_bank_acct", :name => "partner[bank_acct]"
      assert_select "input#partner_is_public_accounting", :name => "partner[is_public_accounting]"
      assert_select "input#partner_has_pay_announce", :name => "partner[has_pay_announce]"
      assert_select "input#partner_business_id", :name => "partner[business_id]"
    end
  end
end
