class CreateTrackings < ActiveRecord::Migration
  def change
    create_table :trackings do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.references :trackable, polymorphic: true, index: true
      t.date :start_at
      t.date :end_at
      t.integer :color_id
      t.timestamps null: false
    end

    add_index :trackings, :trackable_type
    add_index(:trackings,
      [:user_id, :trackable_id, :trackable_type, :start_at],
      unique: true, name: "index_trackings_unique_trackable")
  end
end
