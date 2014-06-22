# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    'public/uploads'
  end

  process resize_to_fill: [170, 170]
  process convert: :png

  def extension_white_list
     %w(jpg jpeg gif png)
  end

  def filename
    if original_filename.present? && super.present?
      "#{super.chomp(File.extname(super))}.png"
    end
  end
end
