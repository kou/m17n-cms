class Site < ActiveRecord::Base
  DEFAULT_NAME = "default"
  class << self
    def default
      find_or_create_by_name(DEFAULT_NAME)
    end
  end

  def blank_configuration?
    title.blank? and !have_ftp_configuration?
  end

  def have_ftp_configuration?
    !ftp_host.blank? and !ftp_path.blank?
  end
end
