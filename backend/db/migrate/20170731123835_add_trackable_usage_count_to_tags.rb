class AddTrackableUsageCountToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :trackable_usages_count, :integer, default: 0
  end
end
