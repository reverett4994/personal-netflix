class Genre < ActiveRecord::Base
  has_and_belongs_to_many :series
  has_and_belongs_to_many :videos
  belongs_to :user


  def nameortype
    name
  end
end
