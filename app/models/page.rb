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

  def sorted_available_contents
    sorted_contents.reject do |content|
      content.body.blank?
    end
  end

  def html_path(directory=nil)
    File.join(*[directory, "#{name}.html"].compact)
  end
end
