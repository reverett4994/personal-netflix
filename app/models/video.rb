class Video < ActiveRecord::Base
   has_and_belongs_to_many :genres
   belongs_to :series
   belongs_to :user
   validate :content_type
   before_validation :add_title_and_desc
   mount_uploader :content, ContentUploader
  #  has_attached_file :content, default_url: "/images/:style/missing.png"
   # validates_attachment_content_type :content, content_type: /\Avideo\/.*\z/
   # validates :content, attachment_presence: true

   before_destroy :delete_content

  private
  def set_success(format, opts)
    self.success = true
  end

  def delete_content
    self.remove_content!
  end

  def content_type
    if self.content.file.extension.downcase.in?(["mp4","webm","ogg"]) == false
      errors.add(:content_type, "has to be either mp4, webm or ogg")
    end
  end

  def add_title_and_desc
    @search = Tmdb::Search.new
    @search.resource('tv')
    if self.series
      @search.query(self.series.title)
      if @search.fetch.any?
        @tv_series_id=@search.fetch[0]["id"]
        @episode = Tmdb::Episode.detail(@search.fetch[0]["id"] , self.season, self.episode)
        @episode_title= @episode["name"]
        @episode_desc= @episode["overview"]
        @episode_date= @episode["air_date"]
        self.title=@episode_title
        self.desc=@episode_desc
        self.date=@episode_date.to_date
      end
    end
  end

end
