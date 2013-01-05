class Intervention < ActiveRecord::Base
  has_paper_trail
  has_magick_columns address: :string, kind: :string, number: :integer

  KINDS = {
    accident: 'a'
  }.with_indifferent_access.freeze

  attr_accessible :address, :hierarchy_id, :kind, :kind_notes, :near_corner, 
    :number, :observations, :receptor_id

  belongs_to :user, foreign_key: 'receptor_id'

  validates :address, :kind, :number, :receptor_id, presence: true
  validates :number, uniqueness: true

end
