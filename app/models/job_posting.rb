class JobPosting < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_jobs,
    against:  :title,
    using: {
      tsearch: {
        any_word: true,
        prefix: true
      }
    }

  belongs_to :company_profile
  has_one :job_type
  validates :description, presence: true
end
