class AddLastWatchedAndWhereLeftOffToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :left_off, :time
    add_column :videos, :last_watched, :datetime
  end
end
