class DocketUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    model_id = ('%06d' % model.firefighter_id).scan(/\d{3}/).join('/')

    "private/dockets/#{model_id}"
  end

  def cache_dir
    'tmp/uploads'
  end

  def filename
    if original_filename.present? && super.present?
      [Time.new.to_i, super].join('_')
    end
  end

  def extension_white_list
    %w(jpg jpeg png pdf doc docx )
  end
end
