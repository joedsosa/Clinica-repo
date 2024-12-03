# == Schema Information
#
# Table name: medicines
#
#  id           :bigint           not null, primary key
#  description  :text
#  dosage       :string
#  dosage_form  :string
#  instructions :text
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Medicine, type: :model do
  it 'creates a valid medicine' do
    medicine = create(:medicine)
    expect(medicine).to be_valid
  end

  it 'is invalid without a name' do
    medicine = build(:medicine, name: nil)
    expect(medicine).to_not be_valid
    expect(medicine.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without a description' do
    medicine = build(:medicine, description: nil)
    expect(medicine).to_not be_valid
    expect(medicine.errors[:description]).to include("can't be blank")
  end

  it 'is invalid without a dosage' do
    medicine = build(:medicine, dosage: nil)
    expect(medicine).to_not be_valid
    expect(medicine.errors[:dosage]).to include("can't be blank")
  end

  it 'is invalid without a dosage form' do
    medicine = build(:medicine, dosage_form: nil)
    expect(medicine).to_not be_valid
    expect(medicine.errors[:dosage_form]).to include("can't be blank")
  end

  it 'is invalid without instructions' do
    medicine = build(:medicine, instructions: nil)
    expect(medicine).to_not be_valid
    expect(medicine.errors[:instructions]).to include("can't be blank")
  end

  it 'is invalid with a name longer than 50 characters' do
    long_name = 'a' * 51
    medicine = build(:medicine, name: long_name)
    expect(medicine).to_not be_valid
    expect(medicine.errors[:name]).to include('is too long (maximum is 50 characters)')
  end

  it 'is invalid with a description longer than 100 characters' do
    long_description = 'a' * 101
    medicine = build(:medicine, description: long_description)
    expect(medicine).to_not be_valid
    expect(medicine.errors[:description]).to include('is too long (maximum is 100 characters)')
  end

  it 'is invalid with a dosage longer than 100 characters' do
    long_dosage = 'a' * 101
    medicine = build(:medicine, dosage: long_dosage)
    expect(medicine).to_not be_valid
    expect(medicine.errors[:dosage]).to include('is too long (maximum is 100 characters)')
  end

  it 'is invalid with a dosage form longer than 50 characters' do
    long_dosage_form = 'a' * 51
    medicine = build(:medicine, dosage_form: long_dosage_form)
    expect(medicine).to_not be_valid
    expect(medicine.errors[:dosage_form]).to include('is too long (maximum is 50 characters)')
  end

  it 'is invalid with instructions longer than 100 characters' do
    long_instructions = 'a' * 101
    medicine = build(:medicine, instructions: long_instructions)
    expect(medicine).to_not be_valid
    expect(medicine.errors[:instructions]).to include('is too long (maximum is 100 characters)')
  end

  it 'supports filtering by name' do
    create(:medicine, name: 'Aspirin')
    create(:medicine, name: 'Ibuprofen')

    results = Medicine.filter_by_name('asp')
    expect(results.pluck(:name)).to include('Aspirin')
    expect(results.pluck(:name)).not_to include('Ibuprofen')
  end
end
