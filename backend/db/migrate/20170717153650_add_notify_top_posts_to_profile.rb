class AddNotifyTopPostsToProfile < ActiveRecord::Migration
  def change
   add_column :profiles, :notify_top_posts, :boolean, default: true
  end
end
