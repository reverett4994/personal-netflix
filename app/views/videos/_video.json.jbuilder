json.extract! video, :id, :type, :title, :season, :episode, :desc, :date, :created_at, :updated_at
json.url video_url(video, format: :json)
