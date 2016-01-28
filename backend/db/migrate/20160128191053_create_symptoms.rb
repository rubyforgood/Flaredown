class CreateSymptoms < ActiveRecord::Migration
  def up
    create_table :symptoms do |t|
      t.boolean :global, default: true
      t.timestamps null: false
    end
    Symptom.create_translation_table! name: :string
  end

  def down
    drop_table :symptoms
    Symptom.drop_translation_table!
  end
end
