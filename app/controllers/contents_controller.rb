class ContentsController < ApplicationController
  def new
    @uploader = Video.new.content
    @uploader.success_action_redirect = new_video_url
  end

end
