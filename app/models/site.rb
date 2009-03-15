require 'uri'

class Site < ActiveRecord::Base
  DEFAULT_NAME = "default"
  class << self
    def default
      find_or_create_by_name(DEFAULT_NAME)
    end
  end

  validates_format_of :ftp_host, :with => URI::HOST, :allow_blank => true
  validates_format_of :ftp_path, :with => URI::ABS_PATH, :allow_blank => true

  before_validation :repair_ftp_host, :repair_ftp_path

  def blank_configuration?
    title.blank? and !have_ftp_configuration?
  end

  def have_ftp_configuration?
    !ftp_host.blank? and !ftp_path.blank?
  end

  private
  def repair_ftp_host
    return if ftp_host.blank?
    self.ftp_host = ftp_host.strip
  end

  def repair_ftp_path
    return if ftp_path.blank?
    self.ftp_path = ftp_path.strip
    self.ftp_path = "/#{ftp_path}" unless ftp_path.starts_with?("/")
  end
end
