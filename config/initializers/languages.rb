# -*- coding: utf-8 -*-

AVAILABLE_LANGUAGES = [
                       "bn", # ベンガル語
                       "en", # 英語
                       "es", # スペイン語
                       "ja", # 日本語
                       "ko", # 韓国語
                       "ms", # マレー語
                       "ru", # ロシア語
                       "th", # タイ語
                       "vi", # ベトナム語
                       "zh", # 中国語
                      ]

langs = Dir[File.join(RAILS_ROOT, "public", "tiny_mce", "langs", "*.js")]
TINY_MCE_AVAILABLE_LANGUAGES = langs.collect do |path|
  File.basename(path, ".*")
end
