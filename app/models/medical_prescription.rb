# == Schema Information
#
# Table name: medical_prescriptions
#
#  id              :bigint           not null, primary key
#  dosage          :string           not null
#  end_date        :date
#  frequency       :string           not null
#  instructions    :text
#  medication_name :string           not null
#  start_date      :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  doctor_id       :bigint           not null
#  patient_id      :bigint           not null
#
# Indexes
#
#  index_medical_prescriptions_on_doctor_id   (doctor_id)
#  index_medical_prescriptions_on_patient_id  (patient_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctor_id => doctors.id)
#  fk_rails_...  (patient_id => patients.id)
#
class MedicalPrescription < ApplicationRecord
  # Associations
  belongs_to :doctor
  belongs_to :patient

  # Validations
  validates :medication_name, presence: true, length: { maximum: 255 }, allow_nil: false
  validates :dosage, presence: true, length: { maximum: 100 }, allow_nil: false
  validates :frequency, presence: true, length: { maximum: 100 }, allow_nil: false
  validates :start_date, presence: true, allow_nil: false
  validates :end_date, presence: true, allow_nil: false
  validates :instructions, length: { maximum: 500 }, allow_nil: true
  validate :end_date_after_start_date

  # Scopes for filtering
  scope :filter_by_medication_name, ->(medication_name) { where('medication_name ILIKE ?', "%#{medication_name}%") }
  scope :filter_by_start_date, ->(start_date) { where('start_date >= ?', start_date) }
  scope :filter_by_end_date, ->(end_date) { where('end_date <= ?', end_date) }

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    errors.add(:end_date, 'must be after the start date') if end_date <= start_date
  end
end
