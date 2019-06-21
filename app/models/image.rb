class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  belongs_to :user

  def render_json
    { id: id, user_id: user_id, image_url: "#{S3_PATH}#{JSON.parse(image_data)['id']}" }
  end
end
