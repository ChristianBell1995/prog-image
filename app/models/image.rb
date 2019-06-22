class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  belongs_to :user

  IMAGE_EXTENSIONS = %w[jpg png jpeg gif tiff]

  def render_json
    { id: id, user_id: user_id, url: "#{S3_PATH}#{filename}.png" }
  end
end
