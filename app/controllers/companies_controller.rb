class CompaniesController < ApplicationController
 def index
    @companies = Company.order('type_name asc, name asc').select(:type_name, :industry_field, :company_id, :short,:name, :desc, :url).uniq
    respond_to do |format|
      format.xls
    end
  end
end
