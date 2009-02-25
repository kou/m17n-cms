module TinyMceAssetTagHelper
  TINY_MCE_DIR = "#{ActionView::Helpers::AssetTagHelper::ASSETS_DIR}/tiny_mce"

  module TinyMceAsset
    DIRECTORY = 'tiny_mce'.freeze

    def public_directory
      TINY_MCE_DIR
    end

    def directory
      DIRECTORY
    end

    def extension
      nil
    end
  end

  class TinyMceTag < ActionView::Helpers::AssetTag
    include TinyMceAsset
  end
end
