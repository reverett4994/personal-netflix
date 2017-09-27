class AddReletionshipsToModels < ActiveRecord::Migration
  def change
    create_table :genres_series, id: false do |t|
      t.belongs_to :genre, index: true
      t.belongs_to :seris, index: true
    end

    create_table :genres_videos, id: false do |t|
      t.belongs_to :genre, index: true
      t.belongs_to :video, index: true
    end
  end
end
