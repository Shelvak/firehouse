module ErrorLogger
  def self.error(e)
    Bugsnag.notify(e)
    ::Rails.logger.error(e)
  rescue => e
    p e
  end
end
