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
    # thumb = ImageProcessing::MiniMagick
    #   .source(original)
    #   .resize_to_limit!(200, 200)
    # versions[:thumb] = thumb

    # create different mime_types
    pipeline = ImageProcessing::Vips.source(original)
    Image::IMAGE_EXTENSIONS.each do |ext|
      versions[ext.to_sym] = pipeline.convert!(ext)
    end

    versions
  end

  def generate_location(io, context)
    filename = context[:record].filename
    ext = File.extname(context[:metadata]['filename'])
    filename + ext
  end
end
