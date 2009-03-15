class Page < ActiveRecord::Base
  has_many :contents, :dependent => :destroy do
    def find_or_create_by_language(language)
      content = method_missing(:find_or_create_by_language, language)
      if content.title.blank?
        content.update_attribute(:title, content.page.name)
      end
      content
    end
  end
  named_scope :sorted, :order => "name"

  validates_presence_of :name
  validates_uniqueness_of :name

  def sorted_contents
    AVAILABLE_LANGUAGES.collect do |language|
      contents.find_or_create_by_language(language)
    end
  end

  def sorted_available_contents
    AVAILABLE_LANGUAGES.collect do |language|
      content = contents.find_by_language(language)
      content = nil if content and content.body.blank?
      content
    end.compact
  end

  def html_path(directory=nil)
    File.join(*[directory, "#{name}.html"].compact)
  end
end
