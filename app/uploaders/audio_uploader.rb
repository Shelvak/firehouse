class AudioUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    'tmp/uploads'
  end

  #def extension_white_list
  #  %w(mp3 wav)
  #end

  def filename
    original_filename.to_s.normalize_to_filename if original_filename.present?
  end
end
