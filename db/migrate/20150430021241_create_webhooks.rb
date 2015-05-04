class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :url, null: false
      t.belongs_to :game, null: false

      t.timestamps

      t.index [:url, :game_id], unique: true
      t.index :game_id
    end
  end
end
