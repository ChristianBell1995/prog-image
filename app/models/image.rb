class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  belongs_to :user

  def render_json
    { id: id,
      user_id: user_id,
      base_url: "#{S3_PATH}",
      image_data: image_data }
  end
end
