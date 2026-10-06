class Trip < ApplicationRecord
  belongs_to :user
  has_many :photos, dependent: :destroy
  attr_accessor :images

  validates :live_name, presence: true
  validates :event_date, presence: true
  validates :venue, presence: true

  validates :ticket_cost, :transportation_cost, :accommodation_cost, :other_cost,
             numericality: { greater_than_or_equal_to: 0 },
             allow_nil: true

  def total_cost
    ticket_cost.to_i + transportation_cost.to_i + accommodation_cost.to_i + other_cost.to_i
  end
end
