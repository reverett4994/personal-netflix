class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]


  def search
    @search=params[:search]
    if params[:type]==nil || params[:type]=='movie'
      @type='movie'
      @videos=Video.where("title LIKE ? AND production_type LIKE ?","%#{@search}%","movie")
    else
      @type='series'
      @videos=Series.where("title LIKE ?","%#{@search}%")
    end
  end

  def manage_genre
    @genre=Genre.where("name LIKE ?",params[:genre].humanize.downcase)
    @genre=@genre.last
    if params[:movie]=="true"
      @video=Video.find(params[:id])
    else
      @video=Series.find(params[:id])
    end

    if @video.genres.include? @genre
      @video.genres.delete(@genre)
      respond_to do |format|
        format.json { render :json => {:report =>"remove" } }
      end
    else
      @video.genres<<@genre
      respond_to do |format|
        format.json { render :json => {:report =>"add" } }
      end
    end

  end

  def movies
    @videos=Video.where("production_type LIKE ?",'movie')
  end

  def get_movie
    @movie=Video.where("title LIKE ?",params[:title])
    @movie=@movie.last
    @desc=@movie.desc[0..300].gsub(/\s\w+\s*$/, '...')
            if @movie.total_time.nil?
               @remaining=0
            else
               @remaining=(@movie.left_off.to_f/@movie.total_time.to_f)*100
            end
    respond_to do |format|
      format.json { render :json => {:desc =>@desc , :img => @movie.movie_img, id:@movie.id, remaining:@remaining} }
    end
  end

  def set_time
    if params[:time] && params[:video] && params[:total]
      @time=params[:time]
      @video=Video.find(params[:video])
      @video.left_off=@time
      @video.last_watched= Time.now
      @video.total_time=params[:total]
      @video.save
      respond_to do |format|
        format.json { render :json => {:time => @time} }
      end

    else

    end

  end
  # GET /videos
  # GET /videos.json
  def index
    Video.delete_all("title IS NULL")
    @videos = Video.all
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    if @video.production_type.downcase=="tv"
       @search = Tmdb::Search.new
       @search.resource('tv')
       @search.query(@video.series.title)
       @tv_series_id=@search.fetch[0]["id"]
       @episode = Tmdb::Episode.detail(@search.fetch[0]["id"] , @video.season, @video.episode)
       @episode_title= @episode["name"]
       @episode_desc= @episode["overview"]
       @episode_date= @episode["air_date"]
       @genres=[]
       @video.series.genres.each do |g|
         @genres.push(g.name.parameterize.underscore)
       end
       @pics = Tmdb::Episode.images(@tv_series_id, @video.season, @video.episode)
       if @pics["stills"] != nil
         if @pics["stills"][1]==nil
           @poster= "http://image.tmdb.org/t/p/w780/#{ @pics["stills"][0]["file_path"]}"
         else
           @poster= "http://image.tmdb.org/t/p/w780/#{ @pics["stills"][1]["file_path"]}"
         end
       end


       @season_eps= @video.series.videos.where("season LIKE #{@video.season} AND episode > #{@video.episode}").all

       if @season_eps.count > 0
         @season_eps=@season_eps.sort_by &:episode
         @next_eps=@season_eps.first
         gon.next_eps="/videos/#{@next_eps.id}"
       elsif  @video.series.videos.where("season > #{@video.season}").all.count > 0
         @season_eps= @video.series.videos.where("season > #{@video.season}").all
         @season_eps=@season_eps.sort_by {|x| [x.season, x.episode] }
         @next_eps=@season_eps.first
         gon.next_eps="/videos/#{@next_eps.id}"
       else
         gon.next_eps="end"
       end
       gon.genre_id = @video.series.id
       gon.movie=false

     elsif @video.production_type.downcase == "movie"
       @search = Tmdb::Search.new
       @search.resource('movie')
       @search.query(@video.title)
       if @search.fetch[0] != nil
         @movie_id=@search.fetch[0]["id"]
         @movie = Tmdb::Movie.detail(@movie_id)
         @movie_desc=@movie["overview"]
         @movie_date=@movie["release_date"]
         @poster= "http://image.tmdb.org/t/p/w780/#{ @movie["backdrop_path"]}"
       else
          @poster= "/placeholder.jpg"
       end
       gon.genre_id = @video.id
       gon.movie=true
       @genres=[]
       @video.genres.each do |g|
         @genres.push(g.name.parameterize.underscore)
       end
     end

     gon.genres=@genres
     gon.id = @video.id
     if @video.left_off != nil
       gon.start=0.00+@video.left_off
     else
       gon.start=0.00
     end

  end

  # GET /videos/new
  def new
    @video = current_user.videos.build
    @video.update_attribute :key, params[:key] # different than documentation!!
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = current_user.videos.build(video_params)
    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to "/", notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:content,:production_type, :title, :season, :episode, :desc, :date, :series_id, genre_ids:[])
    end
end
