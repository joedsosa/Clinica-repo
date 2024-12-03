# == Schema Information
#
# Table name: subscriptions
#
#  id                   :bigint           not null, primary key
#  email                :string           not null
#  first_name           :string           not null
#  last_name            :string           not null
#  terms_and_conditions :boolean          default(FALSE), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :subscription do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    terms_and_conditions { true } # Asegúrate de que este campo esté en true
  end
end
