class CreateWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :weathers do |t|
      t.date :date
      t.string :postal_code
      t.string :icon
      t.string :summary
      t.float :temperature_min
      t.float :temperature_max
      t.float :precip_intensity
      t.float :pressure
      t.float :humidity

      t.timestamps null: false
    end

    add_index :weathers, %i[date postal_code], unique: true
  end
end
