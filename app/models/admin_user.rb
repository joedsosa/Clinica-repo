# == Schema Information
#
# Table name: admin_users
#
#  id                           :bigint           not null, primary key
#  crypted_password             :string
#  email                        :string           not null
#  remember_me_token            :string
#  remember_me_token_expires_at :datetime
#  salt                         :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email              (email) UNIQUE
#  index_admin_users_on_remember_me_token  (remember_me_token)
#
class AdminUser < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :remember

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
end
