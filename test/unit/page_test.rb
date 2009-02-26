require 'test_helper'

class PageTest < ActiveSupport::TestCase
  def test_contents
    assert_equal([contents(:index_en), contents(:index_ja)],
                 pages(:index).contents.sort_by(&:language))
  end
end
