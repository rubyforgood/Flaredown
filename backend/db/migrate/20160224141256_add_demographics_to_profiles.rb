class AddDemographicsToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :ethnicity_ids_string, :string
    add_column :profiles, :day_habit_id, :string
    add_column :profiles, :education_level_id, :string
    add_column :profiles, :day_walking_hours, :integer
  end
end
