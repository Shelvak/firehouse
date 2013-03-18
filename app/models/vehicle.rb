class Vehicle < ActiveRecord::Base
  has_paper_trail

  belongs_to :mobile_intervention
  has_many :persons

  attr_accessible :mark, :model, :year, :domain, :mobile_intervention_id

  end
