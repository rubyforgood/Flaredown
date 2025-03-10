class AddPressureAndTemperatureSettingsToProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :pressure_units, :integer, default: 0
    add_column :profiles, :temperature_units, :integer, default: 0
  end
end
