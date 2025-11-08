class CreateUserConditions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_conditions do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :condition, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
