require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  def test_page
    assert_equal(pages(:index), contents(:index_ja).page)
  end

  def test_html_path
    assert_equal("index-ja.html", contents(:index_ja).html_path)
    assert_equal("dir/index-ja.html", contents(:index_ja).html_path("dir"))
  end
end
