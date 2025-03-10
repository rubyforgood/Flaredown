class CreateConditions < ActiveRecord::Migration[7.1]
  def up
    create_table :conditions do |t|
      t.boolean :global, default: true
      t.timestamps null: false
    end
    Condition.create_translation_table! name: :string
  end

  def down
    drop_table :conditions
    Condition.drop_translation_table!
  end
end
