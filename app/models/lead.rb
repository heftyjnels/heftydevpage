class Lead < ApplicationRecord
  validates :name, presence: true, length: {maximum: 100}
  validates :email, presence: true, length: {maximum: 254},
    format: {with: /\A[^@\s]+@[^@\s]+\z/, message: "must be a valid email address"}
  validates :message, presence: true, length: {maximum: 5000}
  validates :company, length: {maximum: 200}

  attribute :company_url, :string
end
