# == Schema Information
#
# Table name: medical_record_notes
#
#  id                :bigint           not null, primary key
#  description       :text             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  doctor_id         :bigint           not null
#  medical_record_id :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_medical_record_notes_on_doctor_id          (doctor_id)
#  index_medical_record_notes_on_medical_record_id  (medical_record_id)
#  index_medical_record_notes_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctor_id => doctors.id)
#  fk_rails_...  (medical_record_id => medical_records.id)
#  fk_rails_...  (user_id => users.id)
#
class MedicalRecordNote < ApplicationRecord
  include Filterable

  # Medical record note belongs to a doctor
  belongs_to :doctor

  # Medical record note has been done by an user
  belongs_to :user

  # Medical record note belongs to a medical record
  belongs_to :medical_record

  # Medical record note has a note field
  # that can contain up to 500 characters
  # and cannot be null
  validates :description, presence: true, length: { maximum: 500 }

  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_doctor_id, ->(doctor_id) { where(doctor_id: doctor_id) }
  scope :filter_by_medical_record_id, ->(medical_record_id) { where(medical_record_id: medical_record_id) }
end
