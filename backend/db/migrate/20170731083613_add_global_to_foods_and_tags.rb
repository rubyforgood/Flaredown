class AddGlobalToFoodsAndTags < ActiveRecord::Migration
  def change
    add_column :foods, :global, :boolean, default: true
    add_column :tags, :global, :boolean, default: true
  end
end
