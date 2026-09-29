class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.references :trip, null: false, foreign_key: true
      t.string :image, null: false

      t.timestamps
    end
  end
end
