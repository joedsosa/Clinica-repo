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
FactoryBot.define do
  factory :medical_record_note do
    # Needs a description, belongs to a doctor, belongs to a user, belongs to a medical record
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    association :doctor
    association :user
    association :medical_record
  end
end
