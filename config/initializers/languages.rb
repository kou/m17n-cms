# -*- coding: utf-8 -*-

AVAILABLE_LANGUAGES = [
 "bn", # ベンガル語
 "es", # スペイン語
 "fr", # フランス語
 "id", # インドネシア語
 "ja", # 日本語
 "ko", # 韓国語
 "ms", # マレー語
 "ru", # ロシア語
 "th", # タイ語
 "vi", # ベトナム語
 "zh", # 中国語
]
LANGUAGE_TO_COUNTRY = {
 "bn" => "bd", # バングラディッシュ
 "ja" => "jp", # 日本
 "ko" => "kp", # 韓国
 "ms" => "my", # マレーシア
 "vi" => "vn", # ベトナム
 "zh" => "cn", # 中国
}

langs = Dir[File.join(RAILS_ROOT, "public", "tiny_mce", "langs", "*.js")]
TINY_MCE_AVAILABLE_LANGUAGES = langs.collect do |path|
  File.basename(path, ".*")
end
TINY_MCE_FALLBACK_LANGUAGES = {
  "id" => "ms",
}
