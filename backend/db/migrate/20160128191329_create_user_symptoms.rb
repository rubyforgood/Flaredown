class CreateUserSymptoms < ActiveRecord::Migration[5.1]
  def change
    create_table :user_symptoms do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :symptom, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
