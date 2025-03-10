class AddNotifyToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :notify, :boolean, default: true
  end
end
