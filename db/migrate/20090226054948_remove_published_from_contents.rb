class RemovePublishedFromContents < ActiveRecord::Migration
  def self.up
    remove_column :contents, :published
  end

  def self.down
    add_column :contents, :published, :boolean
  end
end
