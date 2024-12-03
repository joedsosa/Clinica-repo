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
FactoryBot.define do
  factory :doctor do
    # Set all the attributes for the doctor model
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    specialty { 'Ortopeda' }
    start_working_at { DateTime.now }
    end_working_at { DateTime.now + 1.hour }
  end
end
