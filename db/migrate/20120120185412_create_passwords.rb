class CreatePasswords < ActiveRecord::Migration
  def change
    create_table :passwords do |t|
      t.belongs_to :user, :null => false
      t.text :name, :null => false
      t.text :login_name
      t.text :url
      t.text :description
      t.text :iv, :null => false
      t.text :cipher_text, :null => false
      t.timestamps
    end
  end
end
