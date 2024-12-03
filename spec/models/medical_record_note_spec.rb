# == Schema Information
#
# Table name: medical_record_notes
#
#  id                :bigint           not null, primary key
#  description       :text             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  doctor_id         :bigint           not null
#  medical_record_id :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_medical_record_notes_on_doctor_id          (doctor_id)
#  index_medical_record_notes_on_medical_record_id  (medical_record_id)
#  index_medical_record_notes_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (doctor_id => doctors.id)
#  fk_rails_...  (medical_record_id => medical_records.id)
#  fk_rails_...  (user_id => users.id)
#

# spec/models/medical_record_note_spec.rb
require 'rails_helper'

RSpec.describe MedicalRecordNote, type: :model do
  before(:each) do
    @doctor = create(:doctor)
    @patient = create(:patient)
    @medical_record = create(:medical_record, doctor: @doctor, patient: @patient)
  end

  describe 'associations' do
    it { should belong_to(:doctor) }
    it { should belong_to(:medical_record) }
    # it { should belong_to(:patient) }
  end

  it 'creates a valid medical record note' do
    user = create(:user)
    medical_record_note = create(:medical_record_note, user: user, medical_record: @medical_record, description: 'Valid description')

    expect(medical_record_note).to be_valid
  end

  it 'is invalid without a description' do
    user = create(:user)
    medical_record_note = build(:medical_record_note, user: user, medical_record: @medical_record, description: nil)

    expect(medical_record_note).to_not be_valid
    expect(medical_record_note.errors[:description]).to include("can't be blank")
  end

  it 'is invalid with a description longer than 500 characters' do
    user = create(:user)
    long_description = 'a' * 501
    medical_record_note = build(:medical_record_note, user: user, medical_record: @medical_record, description: long_description)

    expect(medical_record_note).to_not be_valid
    expect(medical_record_note.errors[:description]).to include('is too long (maximum is 500 characters)')
  end

  it 'is valid with a description of 500 characters or less' do
    user = create(:user)
    valid_description = 'a' * 500
    medical_record_note = build(:medical_record_note, user: user, medical_record: @medical_record, description: valid_description)

    expect(medical_record_note).to be_valid
  end

  it 'is invalid without a medical record' do
    # medical_record_note = MedicalRecordNote.new(doctor_id: @doctor.id, user_id: @user.id, medical_record_id: @medical_record.id, description)
    medical_record_note = build(:medical_record_note, medical_record: nil)
    expect(medical_record_note).to_not be_valid
  end
end
