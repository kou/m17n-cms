require 'i18n'

module I18n
  class << self
    def normalize_translation_keys_with_sentence_support(locale, key, scope)
      if / / =~ key.to_s
        keys = [locale] + Array(scope) + [key]
        keys.flatten.map { |k| k.to_s.to_sym }
      else
        normalize_translation_keys_without_sentence_support(locale, key, scope)
      end
    end
    alias_method_chain(:normalize_translation_keys, :sentence_support)
  end
end
