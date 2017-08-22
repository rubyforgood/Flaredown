class AddCheckinReminderToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :checkin_reminder, :boolean, default: false
  end
end
