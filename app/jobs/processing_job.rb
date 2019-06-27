class ProcessingJob < ApplicationJob
  include Sidekiq::Status::Worker
  queue_as :default

  def perform(data)
    Shrine::Attacher.promote(data)
  end
end
