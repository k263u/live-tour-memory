class CreateTrips < ActiveRecord::Migration[8.1]
  def change
    create_table :trips do |t|
      t.references :user, null: false, foreign_key: true
      t.string :live_name, null: false
      t.string :artist_name
      t.date :event_date, null: false
      t.string :venue, null: false
      t.string :hotel
      t.string :transportation
      t.integer :cost
      t.text :memo

      t.timestamps
    end
  end
end
