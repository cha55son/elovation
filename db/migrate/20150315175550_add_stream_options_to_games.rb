class AddStreamOptionsToGames < ActiveRecord::Migration
  def change
    add_column :games, :stream_url, :string
    add_column :games, :motion_detected_title, :string
    add_column :games, :motion_absent_title, :string
    add_column :games, :motion_active_at, :datetime
  end
end
