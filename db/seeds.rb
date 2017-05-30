# frozen_string_literal: true
def rand_bool
  [true, false].sample
end

unless AdminUser.any?
  AdminUser.create \
    email: 'admin@example.com',
    password: 'password'
end

unless Category.any?
  12.times do |index|
    index += 1
    Category.create! \
      name_en: "Category-#{index}",
      name_ru: "Категория-#{index}",
      name_zh_cn: "Category-#{index}-zh-cn"
  end
end

unless Good.any?
  25.times do |index|
    index += 1
    Good.create! \
      name_en: "Good-#{index}",
      name_ru: "Товар-#{index}",
      name_zh_cn: "Good-#{index}-zh-cn"
  end
end

unless City.any?
  City.create! name_en: 'Moscow', name_ru: 'Москва', name_zh_cn: 'Moscow-zh-cn'
  City.create! name_en: 'New York', name_ru: 'Нью-Йорк', name_zh_cn: 'New York-zh-cn'
  City.create! name_en: 'Chicago', name_ru: 'Чикаго', name_zh_cn: 'Chicago-zh-cn'
  City.create! name_en: 'London', name_ru: 'Лондон', name_zh_cn: 'London-zh-cn'
  City.create! name_en: 'Mexico', name_ru: 'Мехико', name_zh_cn: 'Mexico-zh-cn'
  City.create! name_en: 'Oslo', name_ru: 'Осло', name_zh_cn: 'Oslo-zh-cn'
end

unless Company.any?
  20.times do |index|
    index += 1
    company = Company.create! \
      name: "Company-#{index}",
      categories: Category.all.sample(2),
      goods: Good.all.sample(3),
      city: City.all.sample,
      url: "example#{index}.com",
      email: "example@example#{index}.com",
      phone: "555-#{index}-123",
      zipcode: "#{index}123456",
      description: "Company-#{index}. description"
    2.times do |alias_index|
      CompanyAlias.create! \
        company_id: company.id,
        name: "C-#{index}-#{alias_index}"
    end
  end
end

unless Review.any?
  125.times do |index|
    index += 1
    Review.create! \
      name: "Review-#{index}",
      company: Company.all.sample,
      status: Review.status.values.sample,
      user: User.all.sample,
      rating: rand(5),
      advantages: "Advantages-#{index}. #{'long ' * 50}",
      disadvantages: "Disdvantages-#{index}. #{'long ' * 50}",
      recommendations: "Recommendations-#{index}. #{'long ' * 50}",
      recommended: rand_bool,
      thankful: rand_bool,
      service: rand(5),
      quality: rand(5),
      stability: rand(5),
      payments: rand(5),
      price: rand(5),
      terms_of_use_confirmed: true
  end
end
