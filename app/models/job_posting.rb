class JobPosting < ApplicationRecord
  belongs_to :company_profile
  belongs_to :job_type
  belongs_to :experience_level
  has_rich_text :description

  enum :salary_currency, { usd: "USD", eur: "EUR", brl: "BRL" }
  enum :salary_period, { daily: "Daily", weekly: "Weekly", monthly: "Monthly", yearly: "Yearly" }
  enum :work_arrangement, { remote: "Remote", hybrid: "Hybrid", in_person: "In Person" }

  validates :title, :salary, :salary_currency, :salary_period, :company_profile, :job_type, :work_arrangement, presence: true
  validates :job_location, presence: true, if: -> { in_person? || hybrid? }
end
