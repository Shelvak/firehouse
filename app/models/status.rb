class Status < ActiveRecord::Base
  belongs_to :trackeable, polymorphic: true
  attr_accessible :name, :trackeable_id, :trackeable_type, :user_id

  before_save :use_only_allowed_statuses

  ALLOWED_STATUSES = %w(open modified finished cancelled fake)

  STATUSES = Hash[ ALLOWED_STATUSES.map { |status| [ status,
     I18n.t("activerecord.attributes.statuses.allowed_statuses.#{status}") ] }
  ]

  def use_only_allowed_statuses
    self.name = ( STATUSES[self.name] ? self.name : ALLOWED_STATUSES[0] )
  end

end