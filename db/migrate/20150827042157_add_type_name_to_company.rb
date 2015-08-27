class AddTypeNameToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :type_name, :string
  end
end
