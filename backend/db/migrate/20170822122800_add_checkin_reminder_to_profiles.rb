class AddCheckinReminderToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :checkin_reminder, :boolean, default: false
    add_column :profiles, :checkin_reminder_at, :datetime
    add_column :profiles, :time_zone_name, :string
    add_column :profiles, :reminder_job_id, :string
  end
end
