class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.bigint :listener_id, null: false
      t.bigint :artist_id, null: false

      t.timestamps
    end

    add_index :subscriptions, [:listener_id, :artist_id]
    add_foreign_key :subscriptions, :listeners, column: :listener_id, on_delete: :cascade
    add_foreign_key :subscriptions, :artists, column: :artist_id, on_delete: :cascade
  end
end
