class CreateUserTreatments < ActiveRecord::Migration
  def change
    create_table :user_treatments do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :treatment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
