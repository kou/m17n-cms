# -*- coding: utf-8 -*-

require 'uri'

class Site < ActiveRecord::Base
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
  def zenkaku_to_hankaku(string)
    string.gsub(/[Ａ-Ｚａ-ｚ。．ー／　]/u) do |zenkaku|
      case zenkaku
      when /[Ａ-Ｚ]/
        [zenkaku.unpack("U")[0] - "Ａ".unpack("U")[0] + "A".unpack("U")[0]].pack("U")
      when /[ａ-ｚ]/
        [zenkaku.unpack("U")[0] - "ａ".unpack("U")[0] + "a".unpack("U")[0]].pack("U")
      when "。", "．"
        "."
      when "ー"
        "-"
      when "　"
        " "
      when "／"
        "/"
      else
        zenkaku
      end
    end
  end

  def repair_ftp_host
    return if ftp_host.blank?
    normalized_ftp_host = zenkaku_to_hankaku(ftp_host)
    normalized_ftp_host = normalized_ftp_host.strip
    self.ftp_host = normalized_ftp_host
  end

  def repair_ftp_path
    return if ftp_path.blank?
    normalized_ftp_path = zenkaku_to_hankaku(ftp_path)
    normalized_ftp_path = normalized_ftp_path.strip
    unless normalized_ftp_path.starts_with?("/")
      normalized_ftp_path = "/#{normalized_ftp_path}"
    end
    self.ftp_path = normalized_ftp_path
  end

  def validate_ftp_host
    return if ftp_host.blank?
    return if URI::HOST =~ ftp_host
    add_invalid_ascii_value_error(:ftp_host, ftp_host)
  end

  def validate_ftp_path
    return if ftp_path.blank?
    return if URI::ABS_PATH =~ ftp_path
    add_invalid_ascii_value_error(:ftp_path, ftp_path, :accept_slash => true)
  end

  def add_invalid_ascii_value_error(key, value, options={})
    case value
    when /\s/
      errors.add(key, :have_space, :value => value)
    when /[?:;'"!@\#$%^&*()\-_+=|~`\[\]{}]/
      errors.add(key, :have_symbol, :value => value)
    when /[^a-zA-Z0-9]/
      errors.add(key, :have_japanese, :value => value)
    else
      if /\\/ =~ value and !options[:accept_slash]
        errors.add(key, :have_symbol, :value => value)
      else
        errors.add(key, :invalid, :value => value)
      end
    end
  end
end
