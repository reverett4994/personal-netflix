class Series < ActiveRecord::Base
  has_and_belongs_to_many :genres
  has_many :videos
  belongs_to :user
  validates :title, length: { minimum: 1 }
end
