require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  def test_page
    assert_equal(pages(:index), contents(:index_ja).page)
  end
end
