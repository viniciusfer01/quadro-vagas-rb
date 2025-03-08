class JobPosting < ApplicationRecord
  belongs_to :company_profile
  has_one :job_type
end
