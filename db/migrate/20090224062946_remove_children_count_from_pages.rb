class RemoveChildrenCountFromPages < ActiveRecord::Migration
  def self.up
    remove_column :pages, :children_count
  end

  def self.down
    add_column :pages, :children_count, :integer
  end
end
