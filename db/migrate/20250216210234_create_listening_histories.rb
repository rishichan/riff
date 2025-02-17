class CreateListeningHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :listening_histories do |t|
      t.bigint :listener_id, null: false
      t.bigint :music_id, null: false
      
      t.timestamps
    end

    add_index :listening_histories, [:listener_id, :music_id]
    add_foreign_key :listening_histories, :listeners, column: :listener_id, on_delete: :cascade
    add_foreign_key :listening_histories, :musics, column: :music_id, on_delete: :cascade
  end
end
