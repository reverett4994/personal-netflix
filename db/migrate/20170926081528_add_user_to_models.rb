class AddUserToModels < ActiveRecord::Migration
  def change
    add_column :videos, :user_id, :integer
    add_column :series, :user_id, :integer
    add_column :genres, :user_id, :integer

  end
end
