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
FactoryBot.define do
  factory :diagnosis do
    association :doctor
    association :patient
    description { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end
