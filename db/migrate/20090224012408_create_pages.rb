class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :parent_id
      t.integer :children_count
      t.string :name
      t.boolean :published

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
