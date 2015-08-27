class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :company_id
      t.string :name
      t.text :desc
      t.timestamps null: false
    end
  end
end
