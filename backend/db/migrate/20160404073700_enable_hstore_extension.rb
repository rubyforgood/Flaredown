class EnableHstoreExtension < ActiveRecord::Migration[7.1]
  def change
    enable_extension "hstore"
  end
end
