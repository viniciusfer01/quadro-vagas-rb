class PopulateCompanyProfileTableJob < ApplicationJob
  queue_as :default

  def perform(name, website_url, contact_email, user_id)
    profile = CompanyProfile.new(name: name, website_url: website_url, contact_email: contact_email, user_id: user_id)
    profile.logo.attach(io: File.open(Rails.root.join("spec/support/files/logo.jpg")), filename: "logo.jpg")
    profile.save!
  end
end
