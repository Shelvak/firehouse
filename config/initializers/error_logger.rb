module ErrorLogger
  def self.error(e)
    Bugsnag.notify(e)
    byebug
    ::Rails.logger.error(e)
  rescue => e
    p e
  end
end
