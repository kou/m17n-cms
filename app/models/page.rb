class Page < ActiveRecord::Base
  has_many :contents
  named_scope :sorted, :order => "name"

  def sorted_contents
    AVAILABLE_LANGUAGES.collect do |language|
      content = contents.find_or_create_by_language(language)
      content.update_attribute(:title, name) if content.title.blank?
      content
    end
  end
end
