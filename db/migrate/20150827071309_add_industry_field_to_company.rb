class AddIndustryFieldToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :industry_field, :string
  end
end
