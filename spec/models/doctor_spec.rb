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
require 'rails_helper'

RSpec.describe Doctor, type: :model do
  # Create tests for the Doctor model CRUD Actions
  it 'should create a doctor' do
    doctor = create(:doctor)
    expect(doctor).to be_valid
  end

  it 'should update a doctor' do
    doctor = create(:doctor)
    doctor.update(first_name: 'John')
    expect(doctor.first_name).to eq('John')
  end

  it 'should delete a doctor' do
    doctor = create(:doctor)
    doctor.destroy
    expect(Doctor.count).to eq(0)
  end

  # Create tests for the Doctor model Validations
  it 'should validate the presence of the first_name attribute' do
    doctor = build(:doctor, first_name: nil)
    expect(doctor).to_not be_valid
  end

  it 'should validate the presence of the last_name attribute' do
    doctor = build(:doctor, last_name: nil)
    expect(doctor).to_not be_valid
  end

  it 'should validate the presence of the specialty attribute' do
    doctor = build(:doctor, specialty: nil)
    expect(doctor).to_not be_valid
  end

  it 'should validate the presence of the start_working_at attribute' do
    doctor = build(:doctor, start_working_at: nil)
    expect(doctor).to_not be_valid
  end

  it 'should validate the presence of the end_working_at attribute' do
    doctor = build(:doctor, end_working_at: nil)
    expect(doctor).to_not be_valid
  end

  it 'should validate the length of the specialty attribute' do
    doctor = build(:doctor, specialty: 'a')
    expect(doctor).to_not be_valid
  end

  it 'should validate the length of the first_name attribute' do
    doctor = build(:doctor, first_name: 'a')
    expect(doctor).to_not be_valid
  end

  it 'should validate the length of the last_name attribute' do
    doctor = build(:doctor, last_name: 'a')
    expect(doctor).to_not be_valid
  end

  it 'should validate the start_working_at before end_working_at' do
    doctor = build(:doctor, start_working_at: DateTime.now, end_working_at: DateTime.now - 1)
    expect(doctor).to_not be_valid
  end
end
