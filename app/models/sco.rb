class Sco < ActiveRecord::Base
  has_paper_trail

  attr_accessible :full_name, :current

  validates :full_name, presence: true

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
end
