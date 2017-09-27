class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :type
      t.string :title
      t.integer :season
      t.integer :episode
      t.text :desc
      t.date :date

      t.timestamps null: false
    end
  end
end
