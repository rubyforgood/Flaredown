class CreateTrackableUsages < ActiveRecord::Migration[5.1]
  def change
    create_table :trackable_usages do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.references :trackable, polymorphic: true, index: true
      t.integer :count, default: 1

      t.timestamps null: false
    end
    add_index :trackable_usages, [:user_id, :trackable_type, :trackable_id], unique: true, name: "index_trackable_usages_on_unique_columns"
  end
end
