# == Schema Information
#
# Table name: diagnoses
#
#  id          :bigint           not null, primary key
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  doctor_id   :integer          not null
#  patient_id  :integer          not null
#
class Diagnosis < ApplicationRecord
  include Filterable

  # Associations
  belongs_to :patient
  belongs_to :doctor

  # Validations
  validates :doctor_id, presence: true
  validates :patient_id, presence: true
  # Both the doctor and the patient must exist
  validates :doctor, presence: true
  validates :patient, presence: true
  validates :description, presence: true, length: { maximum: 500 }

  scope :filter_by_doctor_id, ->(doctor_id) { where(doctor_id: doctor_id) }
  scope :filter_by_patient_id, ->(patient_id) { where(patient_id: patient_id) }
end
