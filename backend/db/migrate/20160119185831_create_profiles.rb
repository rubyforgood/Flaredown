class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :country_id
      t.date :birth_date
      t.string :sex_id
      t.string :onboarding_step_id

      t.timestamps null: false
    end
  end
end
