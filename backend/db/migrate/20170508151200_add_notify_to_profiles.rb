class AddNotifyToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :notify, :boolean, default: true
  end
end
