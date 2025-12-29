class AddPositionReferenceToWeather < ActiveRecord::Migration[5.1]
  def change
    add_reference :weathers, :position, foreign_key: true
  end
end
