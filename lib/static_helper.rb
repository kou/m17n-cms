module StaticHelper
  def content_path(content)
    content.html_path
  end

  module AssetPath
    PROTOCOL_REGEXP = ActionView::Helpers::AssetTagHelper::AssetTag::ProtocolRegexp
    def compute_public_path(source)
      source += ".#{extension}" if missing_extension?(source)
      if PROTOCOL_REGEXP =~ source
        source
      else
        "#{directory}/#{source}"
      end
    end
  end
end
