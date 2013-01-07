class AddIndustryTypeToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :industry_type_id, :integer
  end
end
