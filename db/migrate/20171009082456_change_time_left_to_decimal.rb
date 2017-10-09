class ChangeTimeLeftToDecimal < ActiveRecord::Migration
  def change
    change_column :videos, :left_off, :decimal
  end
end
