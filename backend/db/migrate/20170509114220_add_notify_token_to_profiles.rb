class AddNotifyTokenToProfiles < ActiveRecord::Migration[7.1]
  def up
    add_column :profiles, :notify_token, :string
    Profile.find_each(batch_size: 500) do |profile|
      profile.send(:generate_notify_token)
      profile.save
    end
  end

  def down
    remove_column :profiles, :notify_token
  end
end
