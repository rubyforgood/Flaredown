class AddBetaTesterToProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :beta_tester, :boolean, default: false
  end
end
