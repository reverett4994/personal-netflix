class Video < ActiveRecord::Base
   has_and_belongs_to_many :genres
   belongs_to :series
   belongs_to :user
   mount_uploader :content, ContentUploader
  #  has_attached_file :content, default_url: "/images/:style/missing.png"
   # validates_attachment_content_type :content, content_type: /\Avideo\/.*\z/
   # validates :content, attachment_presence: true



end
