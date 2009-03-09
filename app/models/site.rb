class Site < ActiveRecord::Base
  DEFAULT_NAME = "default"
  class << self
    def default
      find_or_create_by_name(DEFAULT_NAME)
    end
  end

  attr_accessor :ftp_user, :ftp_password
  def blank_configuration?
    title.blank? and ftp_user.blank? and ftp_password.blank?
  end
end
