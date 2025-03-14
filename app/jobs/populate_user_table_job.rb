class PopulateUserTableJob < ApplicationJob
  queue_as :default

  def perform(email_address, password, name, last_name, company_id: nil)
    if company_id.present? && CompanyProfile.exists?(company_id)
      company = CompanyProfile.find("company_id")
      company.users.create!(email_address: email_address, password: password, password_confirmation: password, name: name, last_name: last_name)
    else
      User.create!(email_address: email_address, password: password, password_confirmation: password, name: name, last_name: last_name)
    end
  end
end
