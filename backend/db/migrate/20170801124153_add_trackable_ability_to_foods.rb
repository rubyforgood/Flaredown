class AddTrackableAbilityToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :trackable_usages_count, :integer, default: 0

    create_table :user_foods do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :food, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
