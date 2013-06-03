class Building < ActiveRecord::Base
  has_paper_trail

  belongs_to :mobile_intervention
  has_many :persons

  attr_accessible :address, :description, :floor, :roof, :window, :electrics, :damage, :mobile_intervention_id

  end
