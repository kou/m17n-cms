class Content < ActiveRecord::Base
  belongs_to :page

  def tiny_mcs_language
    if TINY_MCE_AVAILABLE_LANGUAGES.include?(language)
      language
    else
      "en"
    end
  end
end
