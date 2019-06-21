class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
end
