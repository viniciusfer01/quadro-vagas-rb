class PopulateUserTableJob < ApplicationJob
  queue_as :default

  def perform(email_address, name, last_name, company_id: nil)
    if company_id.present? && CompanyProfile.exists?(company_id)
      company = CompanyProfile.find(company_id)
      company.users.create!(email_address: email_address, name: name, last_name: last_name, password: "password")
    else
      User.create!(email_address: email_address, name: name, last_name: last_name, password: "password")
    end
  end
end
