require 'test_helper'

class PageTest < ActiveSupport::TestCase
  def test_contents
    assert_equal([contents(:index_en), contents(:index_ja)],
                 pages(:index).contents.sort_by(&:language))
  end

  def test_sorted_available_contents
    assert_equal([contents(:index_en), contents(:index_ja)],
                 pages(:index).sorted_available_contents.sort_by(&:language))
  end

  def test_html_path
    assert_equal("index.html", pages(:index).html_path)
    assert_equal("dir/index.html", pages(:index).html_path("dir"))
  end

  def test_contents_dependent
    index_contents_ids = [contents(:index_en).id, contents(:index_ja).id]
    assert_equal([contents(:index_en), contents(:index_ja)],
                 Content.find(index_contents_ids))
    pages(:index).destroy
    assert_raise(ActiveRecord::RecordNotFound) do
      Content.find(index_contents_ids)
    end
  end

  def test_find_or_create_by_language(language)
    page = Page.create!(:name => "new-page")
    content = page.find_or_create_by_language("ja")
    assert_equal(content.title, "new-page")
  end
end
