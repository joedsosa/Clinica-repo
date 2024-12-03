# == Schema Information
#
# Table name: medical_records
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  doctor_id  :bigint           not null
#  patient_id :bigint           not null
#
# Indexes
#
#  index_medical_records_on_doctor_id   (doctor_id)
#  index_medical_records_on_patient_id  (patient_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctor_id => doctors.id)
#  fk_rails_...  (patient_id => patients.id)
#
class MedicalRecord < ApplicationRecord
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
  # Medical record has many notes
  has_many :medical_record_notes, dependent: :destroy

  scope :filter_by_doctor_id, ->(doctor_id) { where(doctor_id: doctor_id) }
  scope :filter_by_patient_id, ->(patient_id) { where(patient_id: patient_id) }
end
