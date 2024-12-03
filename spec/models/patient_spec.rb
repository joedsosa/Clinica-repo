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
require 'rails_helper'

RSpec.describe Patient, type: :model do
  it 'creates a valid patient' do
    # Create a patient using the factory
    patient = create(:patient)

    # Test that the patient is valid
    expect(patient).to be_valid
  end
  it 'is invalid without a first name' do
    patient = build(:patient, first_name: nil)
    expect(patient).to_not be_valid
    expect(patient.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid without a last name' do
    patient = build(:patient, last_name: nil)
    expect(patient).to_not be_valid
    expect(patient.errors[:last_name]).to include("can't be blank")
  end

  it 'is valid with a blood type' do
    patient = build(:patient, blood_type: 'O+')
    expect(patient).to be_valid
  end

  it 'is invalid with an incorrect blood type' do
    patient = build(:patient, blood_type: 'Invalid')
    expect(patient).to_not be_valid
    expect(patient.errors[:blood_type]).to include('Invalid is not a valid blood type')
  end

  it 'is invalid if emergency contact phone number is not in correct format' do
    patient = build(:patient, emergency_contact_phone: '123abc')
    expect(patient).to_not be_valid
    expect(patient.errors[:emergency_contact_phone]).to include('is not a valid phone number')
  end

  it 'allows allergies to be nil' do
    patient = build(:patient, allergies: nil)
    expect(patient).to be_valid
  end

  it 'allows current medications to be nil' do
    patient = build(:patient, current_medications: nil)
    expect(patient).to be_valid
  end

  it 'validates the format of emergency contact phone number' do
    patient = build(:patient, emergency_contact_phone: '+15551234')
    expect(patient).to be_valid
    patient = build(:patient, emergency_contact_phone: 'invalid-phone')
    expect(patient).to_not be_valid
    expect(patient.errors[:emergency_contact_phone]).to include('is not a valid phone number')
  end

  it 'is invalid with a first name longer than 50 characters' do
    long_first_name = 'a' * 51
    patient = build(:patient, first_name: long_first_name)
    expect(patient).to_not be_valid
    expect(patient.errors[:first_name]).to include('is too long (maximum is 50 characters)')
  end

  it 'is invalid with a last name longer than 50 characters' do
    long_last_name = 'a' * 51
    patient = build(:patient, last_name: long_last_name)
    expect(patient).to_not be_valid
    expect(patient.errors[:last_name]).to include('is too long (maximum is 50 characters)')
  end
end
