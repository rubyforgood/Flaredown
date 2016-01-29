class CreateTrackings < ActiveRecord::Migration
  def change
    create_table :trackings do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.references :trackable, polymorphic: true, index: true
      t.datetime :start_at
      t.datetime :end_at
    end
    add_index :trackings, :trackable_type
  end
end
