class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  include Sidekiq::Status::Worker
  include Sidekiq::Worker

  belongs_to :user

  IMAGE_EXTENSIONS = %i[jpg png jpeg gif tiff]
  IMAGE_MIME_TYPES = %w[image/jpg image/png image/jpeg image/gif image/tiff]

  STATUS_UPLOADED = 1
  IMAGE_STATUS_MAPPING = {
    0 => 'Still Processing...',
    1 => 'Uploaded!'
  }

  def render_json
    { tracking_id: id, user_id: user_id, message: 'Your image is being processed!' }
  end

  class << self
    def user_images_json(user_id)
      images = where(user_id: user_id).order(id: :desc)
      all_images = []
      images.map do |image|
        image_json = {}
        image_json[:tracking_id] = image.id
        image_json[:file_url] = "#{ApplicationRecord::S3_PATH}#{image.filename}.png"
        image_json[:status] = IMAGE_STATUS_MAPPING[determine_status(image)]
        image_json[:created_at] = image.created_at
        all_images << image_json
      end
      all_images
    end

    private

    def determine_status(image)
      return image.status if image.status == STATUS_UPLOADED

      workers = Sidekiq::Workers.new
      image_worker = workers.select do |_process_id, _thread_id, work|
        image_id = work.dig('payload', 'args', 0, 'arguments', 0, 'record', 1).to_i
        image_id == image.id
      end
      check_job_processing(image_worker, image)
      image.status
    end

    def check_job_processing(worker, image)
      if worker.empty?
        image.update(status: STATUS_UPLOADED)
      else
        job_id = worker.dig(0, 2, 'payload', 'jid')
        job_status = Sidekiq::Status::get job_id, :status
        image.update(status: STATUS_UPLOADED) if job_status == 'complete'
      end
    end
  end
end
