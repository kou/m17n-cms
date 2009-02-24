class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.integer :page_id
      t.string :locale
      t.string :title
      t.text :content
      t.boolean :published

      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
