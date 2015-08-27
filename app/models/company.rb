class Company < ActiveRecord::Base
  def self.dedup
   # find all models and group them on keys which should be common
   grouped = all.group_by{|model| [model.short, model.name, model.url] }
   grouped.values.each do |duplicates|
     # the first one we want to keep right?
     first_one = duplicates.shift # or pop for last one
     # if there are any more left, they are duplicates
     # so delete all of them
     duplicates.each{|double| double.destroy} # duplicates can now be destroyed
   end
 end

end
