class AddMostRecentDosesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :most_recent_doses, :hstore
  end
end
