# == Schema Information
#
# Table name: medicines
#
#  id           :bigint           not null, primary key
#  description  :text
#  dosage       :string
#  dosage_form  :string
#  instructions :text
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :medicine do
    name { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.sentence(word_count: 3) }
    dosage { Faker::Lorem.sentence(word_count: 3) }
    dosage_form { Faker::Lorem.sentence(word_count: 3) }
    instructions { Faker::Lorem.sentence(word_count: 3) }
  end
end
