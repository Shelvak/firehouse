class Docket < ActiveRecord::Base
  has_paper_trail
  mount_uploader :file, DocketUploader

  belongs_to :firefighter

  def file_name
    file? ? file.file.filename : '----'
  end
end
