class AddJobIdToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :reminder_job_id, :string
  end
end
