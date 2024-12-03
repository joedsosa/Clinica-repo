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

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it 'creates a valid subscription' do
    subscription = create(:subscription)
    expect(subscription).to be_valid
  end

  it 'is invalid without an email' do
    subscription = build(:subscription, email: nil)
    expect(subscription).to_not be_valid
    expect(subscription.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with an improperly formatted email' do
    subscription = build(:subscription, email: 'invalid-email')
    expect(subscription).to_not be_valid
    expect(subscription.errors[:email]).to include('must be a valid email')
  end

  it 'is invalid without a first name' do
    subscription = build(:subscription, first_name: nil)
    expect(subscription).to_not be_valid
    expect(subscription.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid without a last name' do
    subscription = build(:subscription, last_name: nil)
    expect(subscription).to_not be_valid
    expect(subscription.errors[:last_name]).to include("can't be blank")
  end

  it 'is invalid if terms_and_conditions is not accepted' do
    subscription = build(:subscription, terms_and_conditions: false)
    expect(subscription).to_not be_valid
    expect(subscription.errors[:terms_and_conditions]).to include('must be accepted')
  end

  it 'is invalid with a first name longer than 50 characters' do
    long_first_name = 'a' * 51
    subscription = build(:subscription, first_name: long_first_name)
    expect(subscription).to_not be_valid
    expect(subscription.errors[:first_name]).to include('is too long (maximum is 50 characters)')
  end

  it 'is invalid with a last name longer than 50 characters' do
    long_last_name = 'a' * 51
    subscription = build(:subscription, last_name: long_last_name)
    expect(subscription).to_not be_valid
    expect(subscription.errors[:last_name]).to include('is too long (maximum is 50 characters)')
  end
end
