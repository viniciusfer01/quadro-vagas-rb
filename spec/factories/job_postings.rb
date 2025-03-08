FactoryBot.define do
  factory :job_posting do
    title { "MyString" }
    company_profile
    salary { "MyString" }
    description { "Something" }
    salary_currency { "MyString" }
    salary_period { "MyString" }
  end
end
