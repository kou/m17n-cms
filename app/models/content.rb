class Content < ActiveRecord::Base
  belongs_to :page

  def tiny_mcs_language
    if TINY_MCE_AVAILABLE_LANGUAGES.include?(language)
      language
    else
      TINY_MCE_FALLBACK_LANGUAGES[language] || "en"
    end
  end

  def html_path(directory=nil)
    File.join(*[directory, "#{page.name}-#{language}.html"].compact)
  end
end
