class AddUserToGame < ActiveRecord::Migration
  def change
    add_reference :games, :player, index: true
  end
end
