class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :company_profile

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, { regular: 0, admin: 10 }
end
