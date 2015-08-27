require 'uri'
require 'nokogiri'
require 'open-uri'

namespace :pull do
  desc "拉取公司ID"
  task company_id: :environment do
   citys =   ["全国","北京","上海","深圳","广州","杭州","成都","南京","武汉","西安","厦门","长沙","苏州","天津
    重庆","郑州","青岛","合肥","福州","济南","大连","珠海","无锡","佛山","东莞","宁波","常州","沈阳","石家庄","昆明","南昌","南宁
    哈尔滨","海口","中山","惠州","贵阳","长春","太原","嘉兴","泰安","昆山","烟台","兰州","泉州"]

  industries = ["不限","移动互联网","电子商务","金融","企业服务","教育","文化娱乐","游戏","O2O","硬件
  社交网络","旅游","医疗健康","生活服务","信息安全","数据服务","广告营销","分类信息","招聘","其他"]

  gjs = ["不限", "应届毕业生", "1年以下", "1-3年", "3-5年", "5-10年", "10年以上"]

    citys.each do |city|
      url_city =  URI.encode(city)
      industries.each do |industry_field|
        url_industry_field =  URI.encode(industry_field)
        gjs.each do |gj|
          url_gj =  URI.encode(gj)
          ["成长型", "成熟型", "已上市"].each do |type_name|
             url_type_name =  URI.encode(type_name)
             (1..30).each do |i|

              default_url = "http://www.lagou.com/jobs/positionAjax.json?jd=" + url_type_name + '&px=default&city=' + url_city
              default_url << "&hy=" + url_industry_field  unless industry_field == "不限"
              default_url << "&gj=" + url_gj  unless gj == "不限"

             response =  RestClient.post default_url,
               { :first => false, :pn => i, :kd => '客服' },
               :content_type => :json,
               :accept => :json

               # 公司列表
               response_json = JSON.parse(response)
               next unless response_json["success"]
               result = response_json["content"]["result"]

               to_store_arr = result.map do |c|
                  {:company_id => c["companyId"],
                    :industry_field => c["industryField"],
                    :type_name => type_name,
                    :city => c["city"]
                    }
                 end.uniq
               # 找到所有 ID
               company_id_arr = to_store_arr.map{|c| c[:company_id] }
               next  if company_id_arr.nil? || company_id_arr.count == 0
               # 一次性查询数据库中是否存在数据
               exists_count = begin
                 Company.where('company_id in (?)', company_id_arr.join(",")).try(:count) || 0
               rescue
                 0
               end
               # 如果数据库中不存在，则直接创建所有
               if exists_count <= 0
                 Company.create(to_store_arr)
               else
                 to_store_arr.each do |c|
                   Company.create(c) unless Company.find_by_company_id(c[:company_id]).present?
                 end
              end
             end
           end
     end
     end
     end
  end

  desc "获取公司详情"
  task company_info: :environment do
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

end
