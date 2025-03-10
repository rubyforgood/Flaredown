class AddNotifyTopPostsToProfile < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :notify_top_posts, :boolean, default: true
  end
end
