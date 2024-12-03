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
class Medicine < ApplicationRecord
  include Filterable
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 100 }
  validates :dosage, presence: true, length: { maximum: 100 }
  validates :dosage_form, presence: true, length: {maximum: 50 }
  validates :instructions, presence: true, length: {  maximum: 100 }

  scope :filter_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
end
