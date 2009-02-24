require 'test_helper'

class PageTest < ActiveSupport::TestCase
  def test_empty_tree
    assert_predicate(pages(:index).children, :empty?)
  end

  def test_tree_order
    assert_equal(["gallery", "join", "summary"],
                 pages(:introduction).children.collect(&:name))
  end

  def test_contents
    assert_equal([contents(:index_en), contents(:index_ja)],
                 pages(:index).contents.sort_by(&:language))
  end
end
