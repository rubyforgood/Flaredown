class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :postal_code, null: false
      t.string :location_name, null: false
      t.decimal :latitude, { precision: 10, scale: 7 }
      t.decimal :longitude, { precision: 10, scale: 7 }
    end
  end
end
