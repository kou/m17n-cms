require 'test_helper'

class PageTest < ActiveSupport::TestCase
  def test_empty_tree
    assert_predicate(pages(:index).children, :empty?)
  end

  def test_tree_order
    assert_equal(["gallery", "join", "summary"],
                 pages(:introduction).children.collect(&:name))
  end
end
