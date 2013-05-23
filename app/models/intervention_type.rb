class InterventionType < ActiveRecord::Base
  has_paper_trail

  belongs_to :father, :class_name => 'InterventionType', :foreign_key => 'intervention_type_id'

  has_many :childrens, :class_name => 'InterventionType'

  attr_accessible :name, :priority, :father, :image, :target, :callback

  end
