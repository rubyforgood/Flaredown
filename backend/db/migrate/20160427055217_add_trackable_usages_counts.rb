class AddTrackableUsagesCounts < ActiveRecord::Migration
  def change
    add_column :conditions,  :trackable_usages_count, :integer, default: 0
    add_column :symptoms,  :trackable_usages_count, :integer, default: 0
    add_column :treatments,  :trackable_usages_count, :integer, default: 0
  end
end
