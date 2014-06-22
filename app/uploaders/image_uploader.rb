# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    'public/uploads'
  end

  process convert: :png
  process resize_to_fill: [170, 170]

  def extension_white_list
     %w(jpg jpeg gif png)
  end
end
