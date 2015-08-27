require 'uri'
require 'nokogiri'
require 'open-uri'

desc "获取公司详情"
task setdata: :environment do
  Company.all.each do |c|
    next if c.name.present?
    # Fetch and parse HTML document
    doc = Nokogiri::HTML(open("http://www.lagou.com/gongsi/" + c.company_id.to_s + ".html"))
    company =  doc.css('#content-container a.hovertips').last
    attrs = company.attributes
    company_short = company.text.gsub(/\s+/, "")
    company_title =  attrs["title"].value
    company_url =  attrs["href"].value
    desc =  doc.css('#company_intro p').text

    c.short = company_short
    c.url = company_url
    c.name = company_title
    c.desc = desc
    c.save
  end
end
