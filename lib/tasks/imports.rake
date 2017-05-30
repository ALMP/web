# frozen_string_literal: true
require 'csv'

namespace :data do
  desc "Delete all companies, goods and industries that doesn't have any UGC"
  task clear: :environment do
    companies = Company.left_joins(:reviews).where(reviews: { company_id: nil })
    companies_bar = ProgressBar.create total: companies.count, title: 'Destroying companies', format: '%t %r: |%B %E|'
    companies.find_each do |company|
      company.destroy
      companies_bar.increment
    end

    categories = Category.where.not(id: Category.joins(companies: :reviews))
    categories_bar = ProgressBar.create total: categories.count, title: 'Destroying categories', format: '%t %r: |%B %E|'
    categories.find_each do |category|
      category.destroy
      categories_bar.increment
    end

    goods = Good.where.not(id: Good.joins(companies: :reviews))
    goods_bar = ProgressBar.create total: goods.count, title: 'Destroying goods', format: '%t %r: |%B %E|'
    goods.find_each do |good|
      good.destroy
      goods_bar.increment
    end
  end

  task import: :environment do
    path = Rails.root.join('db', 'companies-v2.xlsx')

    doc = SimpleXlsxReader.open path

    companies_sheet = doc.sheets[0]
    eng_categories_and_goods_sheet = doc.sheets[1]
    ru_categories_and_goods_sheet = doc.sheets[2]

    # CATEGORIES

    categories_en = eng_categories_and_goods_sheet.rows[4][4..-2]
    categories_ru = ru_categories_and_goods_sheet.rows[4][4..-2]

    categories_progress_bar = ProgressBar.create total: categories_en.count, title: 'Importing Categories', format: '%t %r: |%B %E|'
    categories_en.each_with_index do |name_en, index|
      name_ru = categories_ru[index]

      Category.create! \
        name_en: name_en.tr('_', ' '),
        name_ru: name_ru

      categories_progress_bar.increment
    end

    # GOODS

    goods_en = eng_categories_and_goods_sheet.rows[4..-1].transpose[4..-1].map { |col| col[1..-1] }
    goods_ru = ru_categories_and_goods_sheet.rows[4..-1].transpose[4..-1].map { |col| col[1..-1] }

    goods_progress_bar = ProgressBar.create total: goods_en.flatten.select(&:present?).count, title: 'Importing goods', format: '%t %r: |%B %E|'
    goods_en.each_with_index do |goods, index|
      next if categories_en[index].blank?
      category = Category.where(name: categories_en[index].tr('_', ' ')).first

      goods.each_with_index do |name_en, row_index|
        next if name_en.blank?
        Good.create! \
          category_id: category&.id,
          name_en: name_en,
          name_ru: goods_ru[index][row_index]
        goods_progress_bar.increment
      end
    end

    # COMPANIES

    companies = companies_sheet.rows[3..-1].map { |row| row[3..-1] }
    companies_progress_bar = ProgressBar.create total: companies.count, title: 'Importing companies', format: '%t %r: |%B %E|'
    companies.each do |row|
      name = row[0]
      url = row[1]
      email = row[2]
      phone = row[3]
      categories = row[4]
      goods = row[5]
      description = row[6]
      city = row[7]
      address = row[8]

      category_objects = []
      categories.to_s.split(',').map(&:strip).uniq.each do |name|
        next if name.blank?
        name = 'Financials' if name == 'Financial'
        category_objects << Category.where(name: name).first
      end

      good_objects = []
      goods.to_s.split(',').map(&:strip).uniq.each do |name|
        next if name.blank?
        good_objects << Good.where(name: name).first
      end

      city_object = City.where(name: city).first_or_create

      next if Company.where(name: name).exists?

      company_object = Company.new \
        name: name,
        url: url,
        email: email,
        phone: phone,
        description: description,
        address: address,
        categories: category_objects.select(&:present?),
        goods: good_objects.select(&:present?),
        city: city_object

      company_object.save(validate: true)

      companies_progress_bar.increment
    end
  end
end
