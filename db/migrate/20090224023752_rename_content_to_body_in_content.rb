class RenameContentToBodyInContent < ActiveRecord::Migration
  def self.up
    rename_column(:contents, :content, :body)
  end

  def self.down
    rename_column(:contents, :body, :content)
  end
end
