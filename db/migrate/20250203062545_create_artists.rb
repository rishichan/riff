class CreateArtists < ActiveRecord::Migration[8.0]
  def change
    create_table :artists do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.boolean :emailVerified
      t.string :password_digest, null: false
      t.string :fullName
      t.string :profilePhotoUrl
      t.string :description

      t.timestamps
    end
  end
end
