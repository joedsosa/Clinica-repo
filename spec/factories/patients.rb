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
FactoryBot.define do
  factory :patient do
    first_name { Faker::Name.first_name}
    last_name { Faker::Name.last_name }
    allergies { Faker::Lorem.sentence(word_count: 3) }
    blood_type { 'A+' }
    current_medications { Faker::Lorem.sentence(word_count: 5) }
    emergency_contact_name { Faker::Name.name }
    emergency_contact_phone { '+50499995500' }
    age { 25 }
    birth_date { 25.years.ago }
  end
end

