# -*- coding: utf-8 -*-

require 'uri'

class Site < ActiveRecord::Base
  include AsciiValueValidator

  DEFAULT_NAME = "default"
  class << self
    def default
      find_or_create_by_name(DEFAULT_NAME)
    end
  end

  validate :validate_ftp_host, :validate_ftp_path

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
    normalized_ftp_host = StringConverter.zenkaku_to_hankaku(ftp_host)
    normalized_ftp_host = normalized_ftp_host.strip
    self.ftp_host = normalized_ftp_host
  end

  def repair_ftp_path
    return if ftp_path.blank?
    normalized_ftp_path = StringConverter.zenkaku_to_hankaku(ftp_path)
    normalized_ftp_path = normalized_ftp_path.strip
    unless normalized_ftp_path.starts_with?("/")
      normalized_ftp_path = "/#{normalized_ftp_path}"
    end
    self.ftp_path = normalized_ftp_path
  end

  def validate_ftp_host
    return if ftp_host.blank?
    return if URI::HOST =~ ftp_host
    validate_ascii_value(:ftp_host, ftp_host)
  end

  def validate_ftp_path
    return if ftp_path.blank?
    return if URI::ABS_PATH =~ ftp_path
    validate_ascii_value(:ftp_path, ftp_path, :accept_slash => true)
  end
end
