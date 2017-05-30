require 'csv'
class ImportDefaultCompanies < ActiveRecord::Migration[5.0]
  def up
    CSV.foreach(File.expand_path('./../companies-default.csv', __dir__), :headers => true) do |row|
      name = row[0]
      url = row[1]
      email = row[2]
      phone = row[3]
      categories = row[4]
      goods = row[5]
      city = row[6]
      address = row[7]
      description = row[8]

      category_objects = []
      categories.to_s.split(',').map(&:strip).uniq.each do |name|
        next if name.blank?
        category_objects << Category.where(name: name).first_or_create!
      end

      goods_objects = []
      goods.to_s.split(',').map(&:strip).uniq.each do |name|
        next if name.blank?
        goods_objects << Good.where(name: name).first_or_create!
      end

      if city.present?
        city_object = City.where(name: city).first_or_create!
      end

      company = Company.new do |company|
        company.name = name
        company.url = url
        company.email = email
        company.phone = phone
        company.categories = category_objects
        company.goods = goods_objects
        company.city = city_object
        company.address = address
        company.description = description
      end
      if company.save(validate: false)
        puts "#{company.name} saved" if Rails.env.development?
      end
    end
  end

  def down
  end
end
