class AddScreenNameToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :screen_name, :string
  end
end
