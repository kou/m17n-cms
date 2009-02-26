class RemovePublishedFromPages < ActiveRecord::Migration
  def self.up
    remove_column :pages, :published
  end

  def self.down
    add_column :pages, :published, :boolean
  end
end
