class AddSlugNameToProfiles < ActiveRecord::Migration[7.1]
  def up
    add_column :profiles, :slug_name, :string
    add_index :profiles, :slug_name

    Profile.find_each(batch_size: 500) do |profile|
      profile.send(:ensure_slug_name)
      profile.save
    end
  end

  def down
    remove_column :profiles, :slug_name
    remove_index :profiles, :slug_name
  end
end
