class CreateExportedCompanies < ActiveRecord::Migration
  def change
    create_table :exported_companies do |t|
      t.integer :company_id
    end
  end
end
