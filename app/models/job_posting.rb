class JobPosting < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_jobs,
                  against:  [ :title ],
                  associated_against: {
                    rich_text_description: [ :body ]
                  },
                  using: {
                    trigram: {
                      word_similarity: true
                    }
                  }

  belongs_to :company_profile
  belongs_to :job_type
  belongs_to :experience_level
  has_rich_text :description

  enum :salary_currency, { usd: 0, eur: 10, brl: 20 }
  enum :salary_period, { daily: 0, weekly: 10, monthly: 20, yearly: 30 }
  enum :work_arrangement, { remote: 0, hybrid: 10, in_person: 20 }

  delegate :status, to: :company_profile

  scope :active, -> { includes(company_profile: :user).where(users: { status: "active" }) }

  validates :title, :salary, :salary_currency, :salary_period, :company_profile, :work_arrangement, :description, presence: true
  validates :job_location, presence: true, if: -> { in_person? || hybrid? }

  def self.translate_enum(value, enum_key, from_locale, to_locale)
    translations = I18n.t("activerecord.attributes.job_posting.#{enum_key}")
    key = translations.key(value)
    return nil unless key
    I18n.t("activerecord.attributes.job_posting.#{enum_key}.#{key}", locale: to_locale)
  end
end
