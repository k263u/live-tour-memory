class Trip < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  attr_accessor :images

  validates :live_name, presence: true
  validates :event_date, presence: true
  validates :venue, presence: true

  def total_cost
    ticket_cost.to_i + transportation_cost.to_i + accommodation_cost.to_i + other_cost.to_i
  end
end
