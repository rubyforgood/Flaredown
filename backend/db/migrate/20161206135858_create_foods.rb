class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :ndb_no

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        Food.create_translation_table!(
          long_desc: { type: :string, null: false },
          shrt_desc: :string,
          comname: :string,
          sciname: :string
        )
      end

      dir.down do
        Food.drop_translation_table!
      end
    end

    add_index :foods, :ndb_no
  end
end
