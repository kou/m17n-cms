# -*- coding: utf-8 -*-
require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  def test_default
    Site.destroy_all
    assert_equal(0, Site.count)

    assert_not_nil(Site.default)
    assert_equal(1, Site.count)
  end

  def test_ftp_host_validation
    assert_valid_attribute(:ftp_host, nil)
    assert_valid_attribute(:ftp_host, "")
    assert_valid_attribute(:ftp_host, "192.168.1.1")
    assert_valid_attribute(:ftp_host, "ftp.example.com")
    assert_valid_attribute(:ftp_host, "ftp")

    assert_not_valid_attribute(["FTPホスト は不正な値です。"],
                               :ftp_host,
                               "example com")
  end

  def test_ftp_path_validation
    assert_valid_attribute(:ftp_path, nil)
    assert_valid_attribute(:ftp_path, "")
    assert_valid_attribute(:ftp_path, "/")
    assert_valid_attribute(:ftp_path, "/directory/")

    assert_not_valid_attribute(["FTPパス は不正な値です。"],
                               :ftp_path,
                               "/have space")
    assert_not_valid_attribute(["FTPパス は不正な値です。"],
                               :ftp_path,
                               "relative-path")
  end

  private
  def assert_valid_attribute(name, value)
    site = Site.default
    site.send("#{name}=", value)
    assert_valid(site)
    site
  end

  def assert_not_valid_attribute(expected_errors, name, value)
    site = Site.default
    site.send("#{name}=", value)
    assert_not_valid(expected_errors, site)
    site
  end
end
