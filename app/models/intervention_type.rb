class InterventionType < ActiveRecord::Base
  has_paper_trail
  mount_uploader :image, ImageUploader

  belongs_to :father, class_name: 'InterventionType', foreign_key:
    'intervention_type_id'
  has_many :childrens, class_name: 'InterventionType'
  has_many :interventions

  #attr_accessible :name, :priority, :father, :target, :callback, :color,
   # :image, :remote_image_url, :intervention_type_id

  validates :name, :color, presence: true

  scope :only_fathers, -> { where(intervention_type_id: nil) }
  scope :only_childrens, -> { !only_fathers }

  def to_s
    self.name
  end

  def has_childrens?
    childrens.any?
  end
end
