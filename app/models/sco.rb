class Sco < ActiveRecord::Base
  has_paper_trail

  attr_accessible :full_name, :current

  validates :full_name, presence: true

  has_many :interventions

  def to_s
    self.full_name
  end

  def activate!
    if self.update_attributes!(current: true)
      Sco.where(current: true).first.desactivate!
    else
      false
    end
  end

  def desactivate!
    self.update_attributes!(current: false)
  end

  def self.current
    where(current: true).first
  end
end
