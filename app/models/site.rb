# -*- coding: utf-8 -*-

require 'uri'

class Site < ActiveRecord::Base
  DEFAULT_NAME = "default"
  class << self
    def default
      find_or_create_by_name(DEFAULT_NAME)
    end
  end

  validate :validate_ftp_host
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
    normalized_ftp_host = ftp_host.gsub(/　/u, ' ')
    normalized_ftp_host = ftp_host.gsub(/[Ａ-Ｚａ-ｚ。．ー]/u) do |zenkaku|
      case zenkaku
      when /[Ａ-Ｚ]/
        [zenkaku.unpack("U")[0] - "Ａ".unpack("U")[0] + "A".unpack("U")[0]].pack("U")
      when /[ａ-ｚ]/
        [zenkaku.unpack("U")[0] - "ａ".unpack("U")[0] + "a".unpack("U")[0]].pack("U")
      when "。", "．"
        "."
      when "ー"
        "-"
      else
        zenkaku
      end
    end
    normalized_ftp_host = normalized_ftp_host.strip
    self.ftp_host = normalized_ftp_host
  end

  def repair_ftp_path
    return if ftp_path.blank?
    self.ftp_path = ftp_path.strip
    self.ftp_path = "/#{ftp_path}" unless ftp_path.starts_with?("/")
  end

  def validate_ftp_host
    return if ftp_host.blank?
    return if URI::HOST =~ ftp_host
    case ftp_host
    when /\s/
      errors.add(:ftp_host, :have_space, :value => ftp_host)
    when /[?:;'"!@\#$%^&*()\-_+=\\|~`\[\]{}]/
      errors.add(:ftp_host, :have_symbol, :value => ftp_host)
    when /[^a-zA-Z0-9]/
      errors.add(:ftp_host, :have_japanese, :value => ftp_host)
    else
      errors.add(:ftp_host, :invalid, :value => ftp_host)
    end
  end
end
