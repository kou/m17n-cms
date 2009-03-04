class Site < ActiveRecord::Base
  DEFAULT_NAME = "default"
  class << self
    def default
      find_or_create_by_name(DEFAULT_NAME)
    end
  end

  attr_accessor :ftp_user, :ftp_password
end
