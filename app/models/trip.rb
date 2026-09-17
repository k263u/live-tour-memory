class Trip < ApplicationRecord
  belongs_to :user

  validates :live_name, presence: true
  validates :event_date, presence: true
  validates :venue, presence: true
end
