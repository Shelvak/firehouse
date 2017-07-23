class Docket < ActiveRecord::Base
  has_paper_trail
  mount_uploader :file, DocketUploader

  belongs_to :firefighter
end
