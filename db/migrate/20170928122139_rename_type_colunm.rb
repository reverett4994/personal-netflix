class RenameTypeColunm < ActiveRecord::Migration
  def change
    rename_column :videos, :type, :production_type
  end
end
