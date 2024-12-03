# == Schema Information
#
# Table name: patients
#
#  id                      :bigint           not null, primary key
#  age                     :integer
#  allergies               :text
#  birth_date              :date
#  blood_type              :string
#  current_medications     :text
#  emergency_contact_name  :string
#  emergency_contact_phone :string
#  first_name              :string           not null
#  last_name               :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class Patient < ApplicationRecord
  # Inclide the Filterable module to allow filtering of patients
  include Filterable

  # Define the associations
  has_many :medical_records, dependent: :destroy

  # Validate that first_name and last_name are present and do not exceed a certain length
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  # Validate that blood_type is either one of the known types
  validates :blood_type, inclusion: { in: %w[A+ A- B+ B- AB+ AB- O+ O-], message: '%<value>s is not a valid blood type' }, presence: true

  # Validate emergency_contact_name, ensuring it doesn't exceed a certain length
  validates :emergency_contact_name, length: { maximum: 100 }, allow_nil: true

  # Validate that current_medications and allergies do not exceed a certain length
  validates :current_medications, length: { maximum: 500 }, allow_nil: true
  validates :allergies, length: { maximum: 500 }, allow_nil: true

  # Custom Validation for emergency_contact_phone that allows a string with up to 12 chars
  validates :emergency_contact_phone, format: { with: /\A\+?\d{1,12}\z/, message: 'is not a valid phone number' }, allow_nil: true

  # Validates the Age to be an integer and greater than 0 and less than 150
  validates :age, numericality: { only_integer: true, greater_than: 0, less_than: 150 }, allow_nil: true

  # Validates the Birth Date to be a date in the past
  # and not in the future
  #validates :birth_date, timeliness: { on_or_before: -> { Date.current }, type: :date }, allow_nil: true

  # Create filter methods for the patient model
  scope :filter_by_first_name, ->(first_name) { where('first_name ILIKE ?', "%#{first_name}%") }
  scope :filter_by_last_name, ->(last_name) { where('last_name ILIKE ?', "%#{last_name}%") }
end
