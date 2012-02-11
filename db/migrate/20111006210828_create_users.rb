class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :email_address, :null => false
      t.text :password_hash, :null => false
      t.text :password_salt, :null => false
      t.text :remember_me_token
      t.text :password_reset_token
      t.text :first_name
      t.text :last_name
      t.text :phone_number
      t.text :ip_addresses
      t.integer :privilege_level, :null => false, :default => 1
      t.integer :login_count, :null => false, :default => 0
      t.datetime :password_reset_sent_at
      t.datetime :last_login
      t.timestamps
    end
  end
end
