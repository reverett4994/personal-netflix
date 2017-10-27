class Video < ActiveRecord::Base

   has_and_belongs_to_many :genres
   belongs_to :series
   belongs_to :user
   validate :content_type
   validate :series_check
   validate :season_episode
   after_validation  :add_title_and_desc
   #validate :add_title_and_desc, :on => :create
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

  def series_check
    if self.production_type !=nil && self.production_type.downcase == "tv"
      if self.series == nil
        errors.add(:video, "must belong to a series")
      end
    end
  end

  def season_episode
    if self.production_type !=nil && self.production_type.downcase == "tv"
      if self.season == nil || self.episode == nil
        errors.add(:video, "must have a season and episode number")
      end
    end
  end

  def add_title_and_desc
    @search = Tmdb::Search.new
    if self.production_type==nil
      errors.add(:type, "must have a tv, movie or other type")
    else
      if self.production_type.downcase == "tv"
        @search.resource('tv')
        if self.series
          @search.query(self.series.title)
          if @search.fetch.any?
            @tv_series_id=@search.fetch[0]["id"]
            @episode = Tmdb::Episode.detail(@search.fetch[0]["id"] , self.season, self.episode)
            @episode_title= @episode["name"]
            @episode_desc= @episode["overview"]
            @episode_date= @episode["air_date"]
            if self.season != nil || self.episode != nil
              @pics = Tmdb::Episode.images(@tv_series_id, self.season, self.episode)
              if @pics["stills"][1]==nil
                @poster= "http://image.tmdb.org/t/p/w780/#{ @pics["stills"][0]["file_path"]}"
              else
                @poster= "http://image.tmdb.org/t/p/w780/#{ @pics["stills"][1]["file_path"]}"
              end

              self.date = @episode_date.to_date
              self.poster = @poster
            end

            if self.title==""
              self.title = @episode_title
            end
            if self.desc=="" || self.desc==nil
              self.desc = @episode_desc
            end
          end
        end
      elsif self.production_type.downcase=="movie"
        @search = Tmdb::Search.new
        @search.resource('movie')
        @search.query(self.title)
        @movie_id=@search.fetch[0]["id"]
        @movie = Tmdb::Movie.detail(@movie_id)
        @movie_desc=@movie["overview"]
        @movie_date=@movie["release_date"]
        @poster= "http://image.tmdb.org/t/p/w780/#{ @movie["poster_path"]}"
        @movie_img="http://image.tmdb.org/t/p/w780/#{ @movie["backdrop_path"]}"
        self.poster=@poster
        self.movie_img=@movie_img
        self.desc=@movie_desc
        self.date=@movie_date.to_date
      end
    end
  end



end
