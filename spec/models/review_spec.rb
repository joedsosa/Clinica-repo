# == Schema Information
#
# Table name: reviews
#
#  id          :bigint           not null, primary key
#  description :text
#  email       :string
#  first_name  :string
#  last_name   :string
#  rating      :integer
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Review, type: :model do
  it 'creates a valid review' do
    # Create a review using the factory
    review = create(:review)

    # Test that the review is valid
    expect(review).to be_valid
  end

  it 'is invalid without an email' do
    review = build(:review, email: nil)
    expect(review).to_not be_valid
    expect(review.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with an improperly formatted email' do
    review = build(:review, email: 'invalid-email')
    expect(review).to_not be_valid
    expect(review.errors[:email]).to include('must be a valid email')
  end

  it 'is invalid without a first name' do
    review = build(:review, first_name: nil)
    expect(review).to_not be_valid
    expect(review.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid without a last name' do
    review = build(:review, last_name: nil)
    expect(review).to_not be_valid
    expect(review.errors[:last_name]).to include("can't be blank")
  end

  it 'is invalid without a rating' do
    review = build(:review, rating: nil)
    expect(review).to_not be_valid
    expect(review.errors[:rating]).to include("can't be blank")
  end

  it 'is invalid with a rating outside the range 0-5' do
    review = build(:review, rating: 6)
    expect(review).to_not be_valid
    expect(review.errors[:rating]).to include('must be between 0 and 5')

    review = build(:review, rating: -1)
    expect(review).to_not be_valid
    expect(review.errors[:rating]).to include('must be between 0 and 5')
  end

  it 'is invalid without a title' do
    review = build(:review, title: nil)
    expect(review).to_not be_valid
    expect(review.errors[:title]).to include("can't be blank")
  end

  it 'is valid with a nil description' do
    review = build(:review, description: nil)
    expect(review).to be_valid
  end

  it 'is invalid with a first name longer than 50 characters' do
    long_first_name = 'a' * 51
    review = build(:review, first_name: long_first_name)
    expect(review).to_not be_valid
    expect(review.errors[:first_name]).to include('is too long (maximum is 50 characters)')
  end

  it 'is invalid with a last name longer than 50 characters' do
    long_last_name = 'a' * 51
    review = build(:review, last_name: long_last_name)
    expect(review).to_not be_valid
    expect(review.errors[:last_name]).to include('is too long (maximum is 50 characters)')
  end

  it 'is invalid with a title longer than 100 characters' do
    long_title = 'a' * 101
    review = build(:review, title: long_title)
    expect(review).to_not be_valid
    expect(review.errors[:title]).to include('is too long (maximum is 100 characters)')
  end

  it 'is invalid with a description longer than 500 characters' do
    long_description = 'a' * 501
    review = build(:review, description: long_description)
    expect(review).to_not be_valid
    expect(review.errors[:description]).to include('is too long (maximum is 500 characters)')
  end
end
