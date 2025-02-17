class CreateListeners < ActiveRecord::Migration[8.0]
  def change
    create_table :listeners do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.boolean :emailVerified
      t.string :password_digest, null: false
      t.string :profilePhotoUrl
      t.timestamps
    end
  end
end
