class AddAdminToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :is_admin, :boolean, default: false, null: false
  end
end
