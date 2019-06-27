require "image_processing/mini_magick"
require "image_processing/vips"

class ImageUploader < Shrine
  Attacher.promote do |data|
    ProcessingJob.perform_later(data)
  end

  Attacher.validate do
    validate_mime_type_inclusion Image::IMAGE_MIME_TYPES
    validate_extension_inclusion Image::IMAGE_EXTENSIONS
  end

  process(:store) do |io|
    versions = { original: io }
    original = io.download
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
