# -*- coding: utf-8 -*-
require 'test_helper'

class PageTest < ActiveSupport::TestCase
  def test_contents
    assert_equal([contents(:index_ja), contents(:index_zh)],
                 pages(:index).contents.sort_by(&:language))
  end

  def test_sorted_available_contents
    assert_equal([contents(:index_ja), contents(:index_zh)],
                 pages(:index).sorted_available_contents.sort_by(&:language))
  end

  def test_html_path
    assert_equal("index.html", pages(:index).html_path)
    assert_equal("dir/index.html", pages(:index).html_path("dir"))
  end

  def test_contents_dependent
    index_contents_ids = [contents(:index_ja).id, contents(:index_zh).id]
    assert_equal([contents(:index_ja), contents(:index_zh)],
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

  def test_name_validation_blank
    page = pages(:index)
    page.name = ""
    assert_not_valid(["名前 を入力してください。"], page)
  end

  def test_name_validation_duplicated
    page = Page.new(:name => "new-page")
    assert_valid(page)
    page.save!

    duplicated_name_page = Page.new(:name => "new-page")
    assert_not_valid(["名前 が重複しています。"], duplicated_name_page)
  end
end
