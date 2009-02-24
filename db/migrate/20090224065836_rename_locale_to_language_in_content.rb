class RenameLocaleToLanguageInContent < ActiveRecord::Migration
  def self.up
    rename_column :contents, :locale, :language
  end

  def self.down
    rename_column :contents, :language, :locale
  end
end
