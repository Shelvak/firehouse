class Vehicle < ActiveRecord::Base
  has_paper_trail

  belongs_to :mobile_intervention
  has_many :people

  attr_accessible :mark, :model, :year, :domain, :damage, :mobile_intervention_id

  validates_presence_of :damage, :domain

  end
