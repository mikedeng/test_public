require 'uri'
require 'nokogiri'
require 'open-uri'
industries = []
industries << "移动互联网"
industries << "电子商务"
industries << "金融"
industries << "企业服务"
industries << "教育"
industries << "文化娱乐"
industries << "游戏"
industries << "O2O"
industries << "硬件"
industries << "社交网络"
industries << "旅游"
industries << "医疗健康"
industries << "生活服务"
industries << "信息安全"
industries << "数据服务"
industries << "广告营销"
industries << "分类信息"
industries << "招聘"
industries << "其他"
industries <<  "不限"

industries.each_with_index do |industry, index|
  desc "rake pull_exec_#{index}"
  task "pull_exec_#{index}" => :environment  do
    puts "pull_exec_#{index} RUNING ....."
    rake_helper_1 industry
  end
end

def rake_helper_1(industry_field)
  #Rails.logger.info 'industry_field: ' + industry_field

    #"北京","上海","深圳","广州","杭州","成都","南京","武汉","西安",
    citys =   ["厦门","长沙","苏州","天津
                 重庆","郑州","青岛","合肥","福州",
                 "济南","大连","珠海","无锡","佛山",
                 "东莞","宁波","常州","沈阳",
                 "石家庄","昆明","南昌","南宁",
                 "哈尔滨","海口","中山","惠州",
                 "贵阳","长春","太原","嘉兴",
                 "泰安","昆山","烟台","兰州",
                 "泉州","全国"]

  # industries = ["移动互联网","电子商务","金融","企业服务","教育","文化娱乐","游戏","O2O","硬件
  # 社交网络","旅游","医疗健康","生活服务","信息安全","数据服务","广告营销","分类信息","招聘","其他", "不限"]

  #gjs = ["应届毕业生", "1年以下", "1-3年", "3-5年", "5-10年", "10年以上", "不限"]

  citys.each do |city|
    url_city =  URI.encode(city)
    #Rails.logger.info 'city: ' + city
    #industries.each do |industry_field|
    puts '行业： ' + industry_field
    url_industry_field =  URI.encode(industry_field)

    ["成长型", "成熟型", "已上市"].each do |type_name|
      #Rails.logger.info 'type_name: ' + type_name
      url_type_name =  URI.encode(type_name)
      (1..30).each do |i|

        default_url = "http://www.lagou.com/jobs/positionAjax.json?jd=" + url_type_name + '&px=default&city=' + url_city
        default_url << "&hy=" + url_industry_field  unless industry_field == "不限"
        #default_url << "&gj=" + url_gj  unless gj == "不限"

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
    #end
    puts '完成行业： ' + industry_field
  end
end
