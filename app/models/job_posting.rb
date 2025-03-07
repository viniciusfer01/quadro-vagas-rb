class JobPosting < ApplicationRecord
  belongs_to :company_profile
  belongs_to :job_type
end
