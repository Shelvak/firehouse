class Sco < ActiveRecord::Base
  has_paper_trail

  attr_accessible :full_name, :current

  validates :full_name, presence: true

  has_many :interventions

  def to_s
    self.full_name
  end

  def activate!
    keep_only_one_current
    Sco.current.try(:desactivate!) if Sco.current
    self.update_attributes!(current: true)
  end

  def desactivate!
    self.update_attributes!(current: false)
  end

  def keep_only_one_current
    if Sco.where(current: true).count > 1
      Sco.where(current: true).order('updated_at DESC').each_with_index do |sco, i|
        sco.desactivate! if i != 0
      end
    end
  end

  def self.current
    where(current: true).first
  end
end
