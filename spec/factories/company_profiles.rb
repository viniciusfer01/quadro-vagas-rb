FactoryBot.define do
  factory :company_profile do
    association :user
    name { "BlinkedOn" }
    website_url { "https://blinkedon.tech" }
    contact_email { "contact@blinkedon.tech" }
  end
end
