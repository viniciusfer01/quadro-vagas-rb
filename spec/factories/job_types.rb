FactoryBot.define do
  factory :job_type do
    name { [ "Remote", "Hybrid", "In-Office" ].sample }
  end
end
