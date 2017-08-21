class AddPositionReferenceToWeather < ActiveRecord::Migration
  def change
    add_reference :weathers, :position, foreign_key: true
  end
end
