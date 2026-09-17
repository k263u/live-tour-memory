class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :trips

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  validates :password, presence: true, length: { minimum: 8 }, confirmation: true
  validates :password_confirmation, presence: true
end
