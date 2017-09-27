class FixTypo < ActiveRecord::Migration
  def change
    rename_column :genres_series, :seris_id, :series_id
  end
end
