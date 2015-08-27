class Content < ActiveRecord::Base
  self.table_name = "content"
  #default_scope { order('行业 ASC, 子行业 ASC, 公司 ASC') }

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |content|
        csv << content.attributes.values_at(*column_names).map(&:to_s).map  do |e|
            ActionController::Base.helpers.strip_tags(e) if e.present?
        end
      end
    end
  end


  def self.to_xls(options = {})
    binding.pry
    XLS.generate(options) do |csv|
      csv << column_names
      all.each do |content|
        csv << content.attributes.values_at(*column_names).map(&:to_s).map  do |e|
            ActionController::Base.helpers.strip_tags(e) if e.present?
        end
      end
    end
  end

end
