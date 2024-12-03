# == Schema Information
#
# Table name: reviews
#
#  id          :bigint           not null, primary key
#  description :text
#  email       :string
#  first_name  :string
#  last_name   :string
#  rating      :integer
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Review < ApplicationRecord
  # Validations for the review attributes
  include Filterable

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email' }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :rating, presence: true, inclusion: { in: 0..5, message: 'must be between 0 and 5' }
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }, allow_nil: true

  # Scopes for filtering
  scope :filter_by_rating, ->(rating) { where(rating: rating) }
  scope :filter_by_first_name, ->(first_name) { where('first_name ILIKE ?', "%#{first_name}%") }
  scope :filter_by_title, ->(title) { where('title ILIKE ?', "%#{title}%") }
end
