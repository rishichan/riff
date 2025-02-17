class AddIndexToMusics < ActiveRecord::Migration[8.0]
  def change
    add_index :musics, :artist_id
  end
end
