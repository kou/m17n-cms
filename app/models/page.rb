class Page < ActiveRecord::Base
  has_many :contents,:dependent => :destroy do
    def find_or_create_by_language(language)
      content = method_missing(:find_or_create_by_language, language)
      if content.title.blank?
        content.update_attribute(:title, content.page.name)
      end
      content
    end
  end
  named_scope :sorted, :order => "name"

  def sorted_contents
    AVAILABLE_LANGUAGES.collect do |language|
      contents.find_or_create_by_language(language)
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
