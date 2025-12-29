class AddMostRecentDosesToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :most_recent_doses, :hstore
  end
end
