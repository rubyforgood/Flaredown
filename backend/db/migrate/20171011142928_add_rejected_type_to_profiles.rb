class AddRejectedTypeToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :rejected_type, :string
  end
end
