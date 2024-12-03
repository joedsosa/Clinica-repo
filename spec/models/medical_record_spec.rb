# == Schema Information
#
# Table name: medical_records
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  doctor_id  :bigint           not null
#  patient_id :bigint           not null
#
# Indexes
#
#  index_medical_records_on_doctor_id   (doctor_id)
#  index_medical_records_on_patient_id  (patient_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctor_id => doctors.id)
#  fk_rails_...  (patient_id => patients.id)
#
# spec/models/medical_record_spec.rb
require 'rails_helper'

RSpec.describe MedicalRecord, type: :model do
  before(:each) do
    @doctor = create(:doctor)
    @patient = create(:patient)
  end

  describe 'associations' do
    it { should belong_to(:doctor) }
    it { should belong_to(:patient) }
    it { should have_many(:medical_record_notes).dependent(:destroy) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      medical_record = MedicalRecord.new(doctor_id: @doctor.id, patient_id: @patient.id)
      expect(medical_record).to be_valid
    end

    it 'is invalid without a doctor' do
      medical_record = MedicalRecord.new(doctor_id: nil, patient_id: @patient.id)
      expect(medical_record).to_not be_valid
      expect(medical_record.errors[:doctor]).to include('must exist', "can't be blank")
    end

    it 'is invalid without a patient' do
      medical_record = MedicalRecord.new(doctor_id: @doctor.id, patient_id: nil)
      expect(medical_record).to_not be_valid
      expect(medical_record.errors[:patient]).to include('must exist', "can't be blank")
    end
  end

  describe 'database constraints' do
    it 'raises an error if trying to create without a doctor_id' do
      # Creación con `doctor_id` nulo, la base de datos debería fallar debido a la restricción NOT NULL
      expect do
        MedicalRecord.new(patient_id: @patient.id).save!(validate: false) # El `validate: false` desactiva las validaciones
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'raises an error if trying to create without a patient_id' do
      # Creación con `patient_id` nulo, la base de datos debería fallar debido a la restricción NOT NULL
      expect do
        MedicalRecord.new(doctor_id: @doctor.id).save!(validate: false) # El `validate: false` desactiva las validaciones
      end.to raise_error(ActiveRecord::NotNullViolation)
    end
  end

  # describe 'dependent destroy' do
  #   it 'destroys associated medical_record_notes when destroyed' do
  #     medical_record = MedicalRecord.create!(doctor_id: @doctor.id, patient_id: @patient.id)
  #     # Creación de una nota médica con un `user_id` válido
  #     medical_record_note = medical_record.medical_record_notes.create!(
  #       doctor_id: @doctor.id,
  #       user_id: @patient.id, # Usamos un paciente como `user_id`
  #       description: 'Routine checkup'
  #     )

  #     expect { medical_record.destroy }.to change { MedicalRecordNote.count }.by(-1)
  #   end
  # end
end
