class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  belongs_to :user

  IMAGE_EXTENSIONS = %w[jpg png jpeg gif tiff]
  IMAGE_MIME_TYPES = %w[image/jpg image/png image/jpeg image/gif image/tiff]

  STATUS_UPLOADED = 1
  STATUS_PENDING_UPLOAD = 0

  def render_json
    { tracking_id: id, user_id: user_id, message: 'Your image is being processed!' }
  end

  class << self
    def user_images_json(user_id)
      images = where(user_id: user_id).order(:asc)
      master_json = []
      images.map do |image|
        image_json = {}
        image_json[:tracking_id] = image.id
        image_json[:file_url] = "#{ApplicationRecord::S3_PATH}#{image.filename}.png"
        image_json[:status] = determine_status(image)
        image_json[:created_at] = image.created_at
        master_json << image_json
      end
      master_json
    end

    private

    def determine_status(image)
      return 'Uploaded' if image.status == STATUS_UPLOADED
      workers = Sidekiq::Workers.new
      workers.each do |_process_id, _thread_id, work|
        p work
        # To do get the image ID from a worker to return status
      end
    end

  end
end
