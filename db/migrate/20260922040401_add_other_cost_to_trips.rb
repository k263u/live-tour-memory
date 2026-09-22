class AddOtherCostToTrips < ActiveRecord::Migration[8.1]
  def change
    add_column :trips, :other_cost, :integer
    add_column :trips, :other_cost_memo, :string
  end
end
