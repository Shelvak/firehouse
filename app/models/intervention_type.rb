class InterventionType < ActiveRecord::Base
  has_paper_trail

  belongs_to :father, :class_name => 'InterventionType', :foreign_key => 'intervention_type_id'

  has_many :childrens, :class_name => 'InterventionType'
  has_many :interventions

  attr_accessible :name, :priority, :father, :target, :callback, :color, :image, :remote_image_url

  validates_presence_of :name, :color

  #validates_numericality_of :priority

  scope :only_fathers, -> { where(intervention_type_id: nil) }

  scope :only_childrens, -> { !only_fathers }

  mount_uploader :image, ImageUploader
end
