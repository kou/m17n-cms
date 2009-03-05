require 'English'
require 'action_controller/test_process'

class StaticGenerator
  include TaskLogger

  class << self
    def output_dir
      output_dir = ENV["M17N_CMS_OUTPUT_DIR"]
      output_dir || File.join(RAILS_ROOT, "public", "static")
    end
  end

  def initialize(output_dir=nil)
    @output_dir = output_dir || self.class.output_dir
  end

  def generate
    log(t("Starting static HTML generation..."))

    ensure_output_dir
    copy_assets
    prepare_objects

    log(t("Generating static HTML..."))
    Page.find(:all).each do |page|
      page.sorted_available_contents.each do |content|
        output_file_name = generate_content(content)
        if content.language == "ja"
          FileUtils.cp(output_file_name, page.html_path(@output_dir))
        end
      end
    end
    log(t("Finished static HTML generation"))
  end

  private
  def ensure_output_dir
    FileUtils.rm_rf(@output_dir) if File.exist?(@output_dir)
    FileUtils.mkdir_p(@output_dir)
  end

  def copy_assets
    copy_images
    copy_stylesheets
  end

  def copy_images
    log(t("Copying images..."))
    output_image_dir = File.join(@output_dir, "images")
    FileUtils.mkdir_p(output_image_dir)
    icons_dir = File.join(ActionView::Helpers::AssetTagHelper::ASSETS_DIR,
                          "images", "icons")
    FileUtils.cp_r(icons_dir, output_image_dir)
    emotions_dir = File.join(TinyMceAssetTagHelper::TINY_MCE_DIR,
                             "plugins", "emotions")
    FileUtils.cp_r(emotions_dir, output_image_dir)
  end

  def copy_stylesheets
    log(t("Copying CSS..."))
    output_stylesheets_dir = File.join(@output_dir, "stylesheets")
    FileUtils.cp_r(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR,
                   output_stylesheets_dir)
  end

  def prepare_objects
    ContentsController.helper(StaticHelper)
    ActionView::Helpers::AssetTagHelper::AssetTag.module_eval do
      include StaticHelper::AssetPath
    end
  end

  def generate_content(content)
    controller = ContentsController.new
    request = ActionController::TestRequest.new("id" => content.id,
                                                "lang" => I18n.locale.to_s)
    request.action = "static"
    response = ActionController::TestResponse.new
    controller.process(request, response)

    output_file_name = content.html_path(@output_dir)
    File.open(output_file_name, "w") do |html|
      html.print(response.body)
    end
    output_file_name
  end

  module StaticHelper
    def content_path(content)
      content.html_path
    end

    def static_content_path(content)
      content.html_path
    end

    def root_path
      "./"
    end

    def normalize_content_body(body)
      body.gsub(/(<(img|a)\s.*?(?:src|href))="(.+?)"/) do |matched_text|
        prefix = $1
        tag = $2
        value = $3
        case tag
        when "img"
          normalize_image_src(prefix, value) || matched_text
        when "a"
          normalize_a_href(prefix, value) || matched_text
        else
          matched_text
        end
      end
    end

    def normalize_image_src(prefix, value)
      if /\A.*\/tiny_mce\/plugins\// =~ value
        relative_image_path = $POSTMATCH
        "#{prefix}=\"images/#{relative_image_path}\""
      else
        nil
      end
    end

    def normalize_a_href(prefix, value)
      if /\A\.\.\/([^\/]+)-([a-z]{2})\z/ =~ value
        page_name = $1
        language = $2
        "#{prefix}=\"#{page_name}-#{language}.html\""
      else
        nil
      end
    end

    module AssetPath
      class << self
        def included(base)
          base.class_eval do
            alias_method_chain :compute_public_path, :static
          end
        end
      end

      PROTOCOL_REGEXP = ActionView::Helpers::AssetTagHelper::AssetTag::ProtocolRegexp
      def compute_public_path_with_static(source)
        source += ".#{extension}" if missing_extension?(source)
        if PROTOCOL_REGEXP =~ source
          source
        else
          "#{directory}/#{source}"
        end
      end
    end
  end
end
