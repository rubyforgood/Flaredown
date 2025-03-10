class AddMostRecentDosesToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :most_recent_doses, :hstore
  end
end
