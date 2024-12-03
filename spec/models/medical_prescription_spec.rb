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

require 'rails_helper'

RSpec.describe MedicalPrescription, type: :model do
  it 'creates a valid medical prescription' do
    doctor = create(:doctor)
    patient = create(:patient)
    prescription = create(:medical_prescription, doctor: doctor, patient: patient)
    expect(prescription).to be_valid
  end

  it 'is invalid without a medication name' do
    prescription = build(:medical_prescription, medication_name: nil)
    expect(prescription).to_not be_valid
    expect(prescription.errors[:medication_name]).to include("can't be blank")
  end

  it 'is invalid without a dosage' do
    prescription = build(:medical_prescription, dosage: nil)
    expect(prescription).to_not be_valid
    expect(prescription.errors[:dosage]).to include("can't be blank")
  end

  it 'is invalid without a frequency' do
    prescription = build(:medical_prescription, frequency: nil)
    expect(prescription).to_not be_valid
    expect(prescription.errors[:frequency]).to include("can't be blank")
  end

  it 'is invalid without a start date' do
    prescription = build(:medical_prescription, start_date: nil)
    expect(prescription).to_not be_valid
    expect(prescription.errors[:start_date]).to include("can't be blank")
  end

  it 'is invalid without an end date' do
    prescription = build(:medical_prescription, end_date: nil)
    expect(prescription).to_not be_valid
    expect(prescription.errors[:end_date]).to include("can't be blank")
  end

  it 'is invalid if end date is before or equal to start date' do
    prescription = build(:medical_prescription, start_date: Date.today, end_date: Date.today - 1)
    expect(prescription).to_not be_valid
    expect(prescription.errors[:end_date]).to include('must be after the start date')
  end

  it 'is valid with nil instructions' do
    prescription = build(:medical_prescription, instructions: nil)
    expect(prescription).to be_valid
  end

  it 'is invalid with a medication name longer than 255 characters' do
    long_name = 'a' * 256
    prescription = build(:medical_prescription, medication_name: long_name)
    expect(prescription).to_not be_valid
    expect(prescription.errors[:medication_name]).to include('is too long (maximum is 255 characters)')
  end

  it 'is invalid with a dosage longer than 100 characters' do
    long_dosage = 'a' * 101
    prescription = build(:medical_prescription, dosage: long_dosage)
    expect(prescription).to_not be_valid
    expect(prescription.errors[:dosage]).to include('is too long (maximum is 100 characters)')
  end

  it 'is invalid with a frequency longer than 100 characters' do
    long_frequency = 'a' * 101
    prescription = build(:medical_prescription, frequency: long_frequency)
    expect(prescription).to_not be_valid
    expect(prescription.errors[:frequency]).to include('is too long (maximum is 100 characters)')
  end

  it 'is invalid with instructions longer than 500 characters' do
    long_instructions = 'a' * 501
    prescription = build(:medical_prescription, instructions: long_instructions)
    expect(prescription).to_not be_valid
    expect(prescription.errors[:instructions]).to include('is too long (maximum is 500 characters)')
  end
end
