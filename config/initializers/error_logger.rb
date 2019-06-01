module ErrorLogger
  def self.error(e)
    Bugsnag.notify(e)
    byebug if Rails.env.development?
    ::Rails.logger.error(e)
  rescue => e
    p e
  end
end
