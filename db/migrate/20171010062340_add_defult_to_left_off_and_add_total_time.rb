class AddDefultToLeftOffAndAddTotalTime < ActiveRecord::Migration
  def change
    change_column :videos, :left_off, :decimal, :default => 0
    add_column :videos, :total_time, :decimal
  end
end
