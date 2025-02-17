class CreateMusic < ActiveRecord::Migration[8.0]
  def change
    create_table :musics do |t|
      t.bigint :artist_id, null: false
      t.string :title, null: false
      t.string :mp3link, null: false
      t.string :details
      t.integer :streams, default: 0
      t.string :genre
      t.timestamps
    end

    add_foreign_key :musics, :artists, column: :artist_id, on_delete: :cascade
  end
end
