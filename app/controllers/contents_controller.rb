class ContentsController < ApplicationController
def index
   @contents = Content.where("获投状态 like '%E轮%' or 获投状态 like '%D轮%'  or  获投状态 like '%C轮%' or 获投状态 like '%B轮%' or 获投状态 like '%A轮%'").order('获投状态 desc, 行业 asc, 子行业 asc')
   respond_to do |format|
     format.html
     format.csv { send_data @contents.to_csv }
     format.xls
   end
 end

 def company_list
    @companies = Company.order("name asc")
    respond_to do |format|
      format.xls
    end
  end

end
