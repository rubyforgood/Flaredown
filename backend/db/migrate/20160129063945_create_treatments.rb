class CreateTreatments < ActiveRecord::Migration
  def up
    create_table :treatments do |t|
      t.boolean :global, default: true
      t.timestamps null: false
    end
    Treatment.create_translation_table! name: :string
  end

  def down
    drop_table :treatments
    Treatment.drop_translation_table!
  end
end
