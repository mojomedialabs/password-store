class CreatePasswords < ActiveRecord::Migration
  def change
    create_table :passwords do |t|
      t.text :name
      t.text :url
      t.text :iv
      t.binary :cipher_text
      t.timestamps
    end
  end
end
