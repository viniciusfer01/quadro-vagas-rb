class CompanyProfile < ApplicationRecord
  belongs_to :user

  has_one_attached :logo

  validates :name, :website_url, :contact_email, :logo, presence: true
  validates :contact_email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :user, uniqueness: true
  validate :logo_image_type
  validate :contact_email_is_not_equal_to_user_email, if: :user_and_contact_email_present?

  private
  def logo_image_type
    allowed_types = [ "image/png", "image/jpeg", "image/jpg" ]

    errors.add(:logo, I18n.t("errors.messages.invalid_image_format")) unless self.logo.content_type.in?(allowed_types)
  end

  def user_and_contact_email_present?
    self.contact_email.present? && self.user.present?
  end

  def contact_email_is_not_equal_to_user_email
    errors.add(:contact_email, I18n.t("errors.messages.invalid_email_equals_user_email")) if self.contact_email == self.user.email_address
  end
end
