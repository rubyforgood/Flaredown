class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      ## Database authenticatable
      t.string :email,                  default: '', null: false
      t.string :encrypted_password,     default: '', null: false

      ## Recoverable
      t.string    :reset_password_token
      t.datetime  :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer   :sign_in_count,          default: 0,  null: false
      t.datetime  :current_sign_in_at
      t.datetime  :last_sign_in_at
      t.string    :current_sign_in_ip
      t.string    :last_sign_in_ip

      ## API authentication token
      t.string :authentication_token, null: false

      ## Invitable
      t.string   :invitation_token
      t.datetime :invitation_created_at
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at
      t.integer  :invitation_limit
      t.integer  :invited_by_id
      t.string   :invited_by_type

      t.timestamps null: false
    end

    add_index :users, :authentication_token, unique: true
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token
    add_index :users, :invitation_token, unique: true
  end
end
