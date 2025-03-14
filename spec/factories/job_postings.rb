FactoryBot.define do
  factory :job_posting do
    sequence(:title) { |n| "Job Title #{n}" }
    sequence(:salary) { |n| "Salary #{n}" }
    salary_currency { :usd }
    salary_period { :monthly }
    work_arrangement { :remote }
    job_location { "City, Country" }
    description { "Something" }

    association :experience_level
    association :job_type
    association :company_profile
  end
end
