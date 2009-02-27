require 'test_helper'

class PageTest < ActiveSupport::TestCase
  def test_contents
    assert_equal([contents(:index_en), contents(:index_ja)],
                 pages(:index).contents.sort_by(&:language))
  end

  def test_html_path
    assert_equal("index.html", pages(:index).html_path)
    assert_equal("dir/index.html", pages(:index).html_path("dir"))
  end
end
