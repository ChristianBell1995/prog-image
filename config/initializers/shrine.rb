require "shrine"
require "shrine/storage/s3"

s3_options = {
  access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region:            ENV['AWS_REGION'],
  bucket:            ENV['S3_BUCKET_MEDIA']
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'shrine-cache', **s3_options),
  store: Shrine::Storage::S3.new(public: true, **s3_options),
}

Shrine.plugin :activerecord
Shrine.plugin :determine_mime_type
# Shrine.plugin :backgrounding

# Shrine::Attacher.promote { |data| PromoteJob.perform_async(data) }
