class AddCostDetailsToTrips < ActiveRecord::Migration[8.1]
  def change
    add_column :trips, :ticket_cost, :integer
    add_column :trips, :transportation_cost, :integer
    add_column :trips, :accommodation_cost, :integer
  end
end
