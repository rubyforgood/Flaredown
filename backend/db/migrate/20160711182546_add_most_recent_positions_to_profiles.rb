class AddMostRecentPositionsToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :most_recent_conditions_positions, :hstore
    add_column :profiles, :most_recent_symptoms_positions, :hstore
    add_column :profiles, :most_recent_treatments_positions, :hstore
  end
end
