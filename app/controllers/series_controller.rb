class SeriesController < ApplicationController
  before_action :set_series, only: [:show, :edit, :update, :destroy]


  def get_videos
    @series=Series.where("title LIKE ?",params[:title])
    @series=@series.last
    @total_seasons=[]
    @series.videos.each do |v|
      @total_seasons.push(v.season)
    end
    @total_seasons = @total_seasons.uniq
    if params[:season]
      @season=params[:season].to_i
      @videos=@series.videos.where("season LIKE ?",@season)
      @most_recent= @series.videos.order("last_watched").last.title
      respond_to do |format|
        format.json { render :json => {:series => @series, :season => @season, :videos => @videos, :last_watched => @most_recent, :total_seasons => @total_seasons} }
      end
    else
      @most_recent= @series.videos.order("last_watched").last.title
      @season=@series.videos.order("last_watched").last.season
      @videos=@series.videos.where("season LIKE ?",@season)
      respond_to do |format|
        format.json { render :json => {:series => @series, :season => @season, :videos => @videos, :last_watched => @most_recent, :total_seasons => @total_seasons} }
      end
    end

  end
  # GET /series
  # GET /series.json
  def index
    @series = Series.all
  end

  # GET /series/1
  # GET /series/1.json
  def show
  end

  # GET /series/new
  def new
    @series = current_user.series.build
  end

  # GET /series/1/edit
  def edit
  end

  # POST /series
  # POST /series.json
  def create
    @series = current_user.series.build(series_params)

    respond_to do |format|
      if @series.save
        format.html { redirect_to @series, notice: 'Series was successfully created.' }
        format.json { render :show, status: :created, location: @series }
      else
        format.html { render :new }
        format.json { render json: @series.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /series/1
  # PATCH/PUT /series/1.json
  def update
    respond_to do |format|
      if @series.update(series_params)
        format.html { redirect_to @series, notice: 'Series was successfully updated.' }
        format.json { render :show, status: :ok, location: @series }
      else
        format.html { render :edit }
        format.json { render json: @series.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /series/1
  # DELETE /series/1.json
  def destroy
    @series.destroy
    respond_to do |format|
      format.html { redirect_to series_index_url, notice: 'Series was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_series
      @series = Series.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def series_params
      params.require(:series).permit(:title, :desc,genre_ids:[])
    end
end
