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
    assert_valid_ftp_host("")
    assert_valid_ftp_host("192.168.1.1")
    assert_valid_ftp_host("ftp.example.com")
    assert_valid_ftp_host("ftp")

    assert_not_valid_ftp_host(["FTPホスト は不正な値です。"], "example com")
  end

  private
  def assert_valid_ftp_host(host)
    site = Site.default
    site.ftp_host = host
    assert_valid(site)
  end

  def assert_not_valid_ftp_host(expected_errors, host)
    site = Site.default
    site.ftp_host = host
    assert_not_valid(expected_errors, site)
  end
end
