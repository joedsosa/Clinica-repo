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
require 'rails_helper'

RSpec.describe Diagnosis, type: :model do
  before(:each) do
    @doctor = create(:doctor)
    @patient = create(:patient)
  end

  describe 'associations' do
    it { should belong_to(:doctor) }
    it { should belong_to(:patient) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      diagnosis = Diagnosis.new(doctor_id: @doctor.id, patient_id: @patient.id, description: 'Test description')
      expect(diagnosis).to be_valid
    end

    it 'is invalid without a doctor' do
      diagnosis = Diagnosis.new(doctor_id: nil, patient_id: @patient.id, description: 'Test description')
      expect(diagnosis).to_not be_valid
      expect(diagnosis.errors[:doctor]).to include('must exist', "can't be blank")
    end

    it 'is invalid without a patient' do
      diagnosis = Diagnosis.new(doctor_id: @doctor.id, patient_id: nil, description: 'Test description')
      expect(diagnosis).to_not be_valid
      expect(diagnosis.errors[:patient]).to include('must exist', "can't be blank")
    end

    it 'is invalid without a description' do
      diagnosis = Diagnosis.new(doctor_id: @doctor.id, patient_id: @patient.id, description: nil)
      expect(diagnosis).to_not be_valid
      expect(diagnosis.errors[:description]).to include("can't be blank")
    end

    it 'is invalid if the description is too long' do
      long_description = 'a' * 501
      diagnosis = Diagnosis.new(doctor_id: @doctor.id, patient_id: @patient.id, description: long_description)
      expect(diagnosis).to_not be_valid
      expect(diagnosis.errors[:description]).to include('is too long (maximum is 500 characters)')
    end
  end
  describe 'database constraints' do
    it 'raises an error if trying to create without a doctor_id' do
      # Usamos `validate: false` para evitar que las validaciones de Rails sean ejecutadas
      expect do
        Diagnosis.create!(patient_id: @patient.id, description: 'Test description')
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises an error if trying to create without a patient_id' do
      expect do
        Diagnosis.create!(doctor_id: @doctor.id, description: 'Test description')
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
