# == Schema Information
#
# Table name: subscriptions
#
#  id                   :bigint           not null, primary key
#  email                :string           not null
#  first_name           :string           not null
#  last_name            :string           not null
#  terms_and_conditions :boolean          default(FALSE), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_email  (email) UNIQUE
#
class Subscription < ApplicationRecord
  # Validations for the subscription attributes
  include Filterable

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email' }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :terms_and_conditions, inclusion: { in: [true], message: 'must be accepted' }

  # Scopes for filtering
  scope :filter_by_email, ->(email) { where('email ILIKE ?', "%#{email}%") }
  scope :filter_by_first_name, ->(first_name) { where('first_name ILIKE ?', "%#{first_name}%") }
  scope :filter_by_last_name, ->(last_name) { where('first_name ILIKE ?', "%#{last_name}%") }
end
