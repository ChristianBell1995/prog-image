require "shrine"
require "shrine/storage/s3"

p ENV['S3_BUCKET_MEDIA']

s3_options = {
  access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region:            ENV['AWS_REGION'],
  bucket:            ENV['S3_BUCKET_MEDIA']
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'shrine-cache', **s3_options),
  store: Shrine::Storage::S3.new(**s3_options),
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
