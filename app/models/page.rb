class Page < ActiveRecord::Base
  include AsciiValueValidator

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

  validate :validate_name
  before_validation :repair_name

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

  private
  def repair_name
    return if name.blank?
    normalized_name = StringConverter.zenkaku_to_hankaku(name)
    normalized_name = normalized_name.strip
    self.name = normalized_name
  end

  def validate_name
    return if name.blank?
    validate_ascii_value(:name, name,
                         :accept_hyphen => true,
                         :accept_underscore => true,
                         :default_is_valid => true)
  end
end
