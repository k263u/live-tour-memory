CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: ENV.fetch("R2_ACCESS_KEY_ID"),
    aws_secret_access_key: ENV.fetch("R2_SECRET_ACCESS_KEY"),
    region: "auto",
    endpoint: ENV.fetch("R2_ENDPOINT"),
    path_style: true
  }

  config.fog_directory = ENV.fetch("R2_BUCKET")
  config.fog_public = false
  config.fog_authenticated_url_expiration = 300
end
