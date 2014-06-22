# encoding: utf-8
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    'uploads'
  end

  def cache_dir
    'tmp/uploads'
  end

  process resize_to_fill: [170, 170]
  process convert: :png

  def extension_white_list
     %w(jpg jpeg gif png)
  end
end
