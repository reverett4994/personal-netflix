class RelationshipBetweenVideosAndSeries < ActiveRecord::Migration
  def change
    add_column :videos, :series_id, :integer
  end
end
