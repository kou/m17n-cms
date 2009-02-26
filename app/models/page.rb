class Page < ActiveRecord::Base
  acts_as_tree :order => "name"
  has_many :contents

  def sorted_contents
    AVAILABLE_LANGUAGES.collect do |language|
      content = contents.find_or_create_by_language(language)
      content.update_attribute(:title, page.name) if content.title.blank?
      content
    end
  end
end
