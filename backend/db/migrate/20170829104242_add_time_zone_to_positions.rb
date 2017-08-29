class AddTimeZoneToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :time_zone_name, :string
    add_reference :profiles, :position, foreign_key: true
  end
end
