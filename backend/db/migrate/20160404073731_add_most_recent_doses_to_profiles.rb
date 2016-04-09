class AddMostRecentDosesToProfiles < ActiveRecord::Migration
  def change
    enable_extension 'hstore'
    add_column :profiles, :most_recent_doses, :hstore
  end
end
