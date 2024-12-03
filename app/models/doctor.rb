# == Schema Information
#
# Table name: doctors
#
#  id               :bigint           not null, primary key
#  end_working_at   :time
#  first_name       :string
#  last_name        :string
#  specialty        :string
#  start_working_at :time
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Doctor < ApplicationRecord
  # Include the Filterable module to allow filtering of doctors
  include Filterable

  # Define the associations
  has_many :medical_records
  has_many :medical_record_notes, through: :medical_records

  # Validations for the Doctor model
  validates_presence_of :first_name, :last_name, :specialty, :start_working_at, :end_working_at

  # Custom validation for the Doctor model
  validate :start_working_at_before_end_working_at

  # Custom validation method for the Doctor model
  def start_working_at_before_end_working_at
    return unless start_working_at && end_working_at
    return unless start_working_at >= end_working_at

    errors.add(:start_working_at, 'must be before end working at')
  end

  # Validate length of the attributes
  validates :specialty, length: {maximum: 50 }
  validates :first_name, length: {maximum: 50 }
  validates :last_name, length: {maximum: 50 }

  # Create filter methods for the patient model
  scope :filter_by_first_name, ->(first_name) { where('first_name ILIKE ?', "%#{first_name}%") }
  scope :filter_by_last_name, ->(last_name) { where('last_name ILIKE ?', "%#{last_name}%") }
end
