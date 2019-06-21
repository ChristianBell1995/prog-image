require "image_processing/mini_magick"
require "image_processing/vips"

class ImageUploader < Shrine
  # plugins and uploading logic
  plugin :processing
  plugin :versions

  process(:store) do |io|
    versions = { original: io }
    # processing goes here
    original = io.download

    # create thumb image
    thumb = ImageProcessing::MiniMagick
      .source(original)
      .resize_to_limit!(200, 200)
    versions[:thumb] = thumb

    # create different mime_types
    IMAGE_EXTENSIONS = %w[jpg png jpeg gif tiff]
    pipeline = ImageProcessing::Vips.source(original)
    IMAGE_EXTENSIONS.each do |ext|
      versions[ext.to_sym] = pipeline.convert!(ext)
    end

    versions
  end

end
