class JobPosting < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_jobs,
                  against:  [ :title, :description ],
                  using: {
                    trigram: {
                      word_similarity: true
                    }
                  }

  belongs_to :company_profile
  belongs_to :job_type

  default_scope { where(status: :active) }

  enum :status, { active: 0, inactive: 1 }

  validates :title, :salary, :salary_currency, :salary_period, :company_profile, :job_type, :description, presence: true
end
