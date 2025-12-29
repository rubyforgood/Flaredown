class AddRejectedTypeToProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :profiles, :rejected_type, :string
  end
end
