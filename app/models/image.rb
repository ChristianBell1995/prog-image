class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)

  belongs_to :user

  IMAGE_EXTENSIONS = %i[jpg png jpeg gif tiff].freeze
  IMAGE_MIME_TYPES = %w[image/jpg image/png image/jpeg image/gif image/tiff].freeze

  STATUS_UPLOADED = 1
  IMAGE_STATUS_MAPPING = {
    0 => 'Still Processing...',
    1 => 'Uploaded!'
  }.freeze

  def render_json
    { tracking_id: id, user_id: user_id, message: 'Your image is being processed!' }
  end

  class << self
    def create_image(user_id, file)
      base_name = SecureRandom.urlsafe_base64
      create(user_id: user_id, filename: "#{user_id}/#{base_name}/#{base_name}", image: file)
    end

    def user_images_json(user_id)
      images = where(user_id: user_id).order(id: :desc)
      all_images = []
      images.map do |image|
        image_json = {}
        image_json[:tracking_id] = image.id
        image_json[:status] = IMAGE_STATUS_MAPPING[determine_status(image)]
        image_json[:file_url] = "#{ApplicationRecord::S3_PATH}#{image.filename}.png"
        image_json[:created_at] = image.created_at
        all_images << image_json
      end
      all_images
    end

    private

    def determine_status(image)
      return image.status if image.status == STATUS_UPLOADED
      image.update(status: STATUS_UPLOADED) if image.image_attacher.stored?
      image.status
    end
  end
end
