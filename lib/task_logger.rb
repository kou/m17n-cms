module TaskLogger
  def t(key, options={})
    I18n.translate(key, {:default => key}.merge(options))
  end

  def log(message)
    if ENV["M17N_CMS_VERBOSE"] == "true"
      puts message
      STDOUT.flush
    end
  end
end
