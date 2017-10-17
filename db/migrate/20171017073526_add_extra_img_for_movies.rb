class AddExtraImgForMovies < ActiveRecord::Migration
  def change
    add_column :videos, :movie_img, :string
  end
end
