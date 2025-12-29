class AddScreenNameToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :screen_name, :string
  end
end
