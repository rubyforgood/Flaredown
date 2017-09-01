class AddTimeZoneToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :time_zone_name, :string
    add_column :profiles, :time_zone_name, :string
  end
end
