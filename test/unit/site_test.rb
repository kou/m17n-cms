require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  def test_default
    Site.destroy_all
    assert_equal(0, Site.count)

    assert_not_nil(Site.default)
    assert_equal(1, Site.count)
  end
end
