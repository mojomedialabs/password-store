class CreatePasswords < ActiveRecord::Migration
  def change
    create_table :passwords do |t|
      t.belongs_to :user, :null => false
      t.text :name
      t.text :url
      t.text :iv
      t.text :cipher_text
      t.timestamps
    end
  end
end
