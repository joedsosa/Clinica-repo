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
FactoryBot.define do
  factory :medical_prescription do
    medication_name { Faker::Lorem.words(number: 2).join(' ') } # Simula un nombre de medicamento
    dosage { "#{rand(1..100)}mg" } # Genera un dosaje aleatorio
    frequency { "#{rand(1..4)} times a day" } # Frecuencia aleatoria
    instructions { Faker::Lorem.sentence(word_count: 10) } # Instrucciones de prueba
    start_date { Date.today }
    end_date { Date.today + rand(1..30).days }
    association :doctor
    association :patient
  end
end
