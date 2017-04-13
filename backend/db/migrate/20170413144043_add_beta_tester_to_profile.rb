class AddBetaTesterToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :beta_tester, :boolean, default: false
  end
end
