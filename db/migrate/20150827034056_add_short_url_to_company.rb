class AddShortUrlToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :short, :string
    add_column :companies, :url, :string

  end
end
