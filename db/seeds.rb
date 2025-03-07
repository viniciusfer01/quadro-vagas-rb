# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Creates three job types
[ "Remote", "Hybrid", "In-Office" ].each do |job_type_name|
  JobType.find_or_create_by!(name: job_type_name)
end

# Creates three company profiles
3.times do |n|
  CompanyProfile.find_or_create_by!(name: "Company Name #{n}", website_url: "http://company#{n}.com", contact_email: "contact@company#{n}.com")
end

# Creates three job postings
JobPosting.find_or_create_by!(title: "Dev React", company_profile: CompanyProfile.first, salary: "1000.00", salary_currency: "USD", salary_period: "Monthly", job_type: JobType.first)
JobPosting.find_or_create_by!(title: "Dev Node", company_profile: CompanyProfile.second, salary: "5000.00", salary_currency: "USD", salary_period: "Monthly", job_type: JobType.second)
JobPosting.find_or_create_by!(title: "Dev RoR", company_profile: CompanyProfile.last, salary: "10000.00", salary_currency: "USD", salary_period: "Monthly", job_type: JobType.last)
