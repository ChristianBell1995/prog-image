class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  S3_PATH = "https://#{ENV['S3_BUCKET_MEDIA']}.s3.#{ENV['AWS_REGION']}.amazonaws.com/"
end
