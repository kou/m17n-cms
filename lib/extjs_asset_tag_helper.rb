module ExtjsAssetTagHelper
  EXTJS_DIR = "#{ActionView::Helpers::AssetTagHelper::ASSETS_DIR}/extjs"
  module ExtjsAsset
    DIRECTORY = 'extjs'.freeze

    def public_directory
      EXJS_DIR
    end

    def directory
      DIRECTORY
    end

    def extension
      nil
    end
  end

  class ExtjsTag < ActionView::Helpers::AssetTag
    include ExtjsAsset
  end
end
