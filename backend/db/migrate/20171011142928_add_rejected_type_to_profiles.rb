class AddRejectedTypeToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :rejected_type, :string
  end
end
