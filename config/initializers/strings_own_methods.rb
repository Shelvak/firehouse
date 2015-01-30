class String
  def normalize
    I18n.transliterate(self)
  end

  def normalize_to_filename
    self.normalize.downcase.gsub(/\s+/, '_')
  end
end
