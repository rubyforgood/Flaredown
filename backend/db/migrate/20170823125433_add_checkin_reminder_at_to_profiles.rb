class AddCheckinReminderAtToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :checkin_reminder_at, :datetime
  end
end
