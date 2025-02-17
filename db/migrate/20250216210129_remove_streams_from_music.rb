class RemoveStreamsFromMusic < ActiveRecord::Migration[8.0]
  def up
    remove_column :musics, :streams
  end

  def down
    add_column :musics, :streams, :integer, default: 0
  end
end
