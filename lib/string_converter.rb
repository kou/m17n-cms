# -*- coding: utf-8 -*-

module StringConverter
  module_function
  def zenkaku_to_hankaku(string)
    string.gsub(/[Ａ-Ｚａ-ｚ。．ー／　]/u) do |zenkaku|
      case zenkaku
      when /[Ａ-Ｚ]/
        [zenkaku.unpack("U")[0] - "Ａ".unpack("U")[0] + "A".unpack("U")[0]].pack("U")
      when /[ａ-ｚ]/
        [zenkaku.unpack("U")[0] - "ａ".unpack("U")[0] + "a".unpack("U")[0]].pack("U")
      when "。", "．"
        "."
      when "ー"
        "-"
      when "　"
        " "
      when "／"
        "/"
      else
        zenkaku
      end
    end
  end
end
