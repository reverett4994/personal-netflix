CarrierWave.configure do |config|
  #config.fog_provider = 'fog/aws'      # required
  config.fog_credentials = {
    provider:              'AWS',       # required
    aws_access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),            # required
    aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),        # required
    region:                ENV.fetch('AWS_REGION')    # optional, defaults to 'us-east-1'

  }
  config.fog_directory  = ENV.fetch('S3_BUCKET_NAME')                 # required

  config.max_file_size     = 10000.megabytes        # defaults to 5.megabytes
end
