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

  def test_name_validation
    assert_valid_name("new-page")
    assert_valid_name("page1")

    page = assert_valid_name("ｗｅｌｃｏｍｅ")
    assert_equal("welcome", page.name)

    page = assert_valid_name(" new_page ")
    assert_equal("new_page", page.name)

    assert_not_valid_name(["名前を入力してください。"], "")
    assert_not_valid_name(["名前が重複しています。"], pages(:introduction).name)
    assert_not_valid_name(["名前にスペースが入っています。"], "new page")
    assert_not_valid_name(["名前に記号が入っています。"], "page?")
    assert_not_valid_name(["名前に記号が入っています。"], "/")
    assert_not_valid_name(["名前に日本語が入っています。"], "ページ")
  end

  private
  def assert_valid_name(value)
    page = Page.find(pages(:index))
    page.name = value
    assert_valid(page)
    page
  end

  def assert_not_valid_name(expected_errors, value)
    page = Page.find(pages(:index))
    page.name = value
    assert_not_valid(expected_errors, page)
    page
  end
end
