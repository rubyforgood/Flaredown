class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.string :date
      t.string :postal_code
      t.string :icon
      t.float :temperature_min
      t.float :temperature_max
      t.float :precip_intensity
      t.float :pressure
      t.float :humidity

      t.timestamps null: false
    end
  end
end
