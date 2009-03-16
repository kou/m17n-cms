# -*- coding: utf-8 -*-
require 'English'
require 'action_controller/test_process'

class StaticDocumentGenerator
  include TaskLogger

  class << self
    def output_dir
      output_dir = ENV["M17N_CMS_DOCUMENT_OUTPUT_DIR"]
      output_dir || File.join(RAILS_ROOT, "doc")
    end
  end

  def initialize(output_dir=nil)
    @output_dir = output_dir || self.class.output_dir
  end

  def generate
    log(t("Started static HTML generation"))

    ensure_output_dir
    copy_assets
    prepare_objects

    log(t("Generating static HTML..."))
    StaticHelper.documents.each do |action|
      generate_document(action)
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
    output_images_dir = File.join(@output_dir, "images")
    FileUtils.mkdir_p(output_images_dir)

    images_dir = File.join(ActionView::Helpers::AssetTagHelper::ASSETS_DIR,
                           "images", "documents")
    FileUtils.cp_r(images_dir, output_images_dir)
  end

  def copy_stylesheets
    log(t("Copying CSS..."))
    output_stylesheets_dir = File.join(@output_dir, "stylesheets")
    FileUtils.cp_r(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR,
                   output_stylesheets_dir)
  end

  def prepare_objects
    DocumentsController.helper(StaticHelper)
    DocumentsController.layout("static_documents")
    ActionView::Helpers::AssetTagHelper::AssetTag.module_eval do
      include StaticHelper::AssetPath
    end
  end

  def generate_document(action)
    controller = DocumentsController.new
    request = ActionController::TestRequest.new("lang" => I18n.locale.to_s)
    request.action = action
    response = ActionController::TestResponse.new
    controller.process(request, response)

    File.open(File.join(@output_dir, "#{action}.html"), "w") do |html|
      html.print(response.body)
    end
  end

  module StaticHelper
    def title
      page_title = document_page_title(controller.action_name)
      h("ドキュメント - #{page_title || '一覧'}")
    end

    def normalize_body(body)
      remove_root_link(fix_link(body))
    end

    def fix_link(body)
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

    def remove_root_link(body)
      body.gsub(/<a\s.*?href="\/">(.+?)<\/a>/) do |matched_text|
        $1
      end
    end

    def normalize_image_src(prefix, value)
      nil
    end

    def normalize_a_href(prefix, value)
      if /\A\/documents\// =~ value
        page_name = $POSTMATCH
        "#{prefix}=\"#{page_name}.html\""
      else
        nil
      end
    end

    module_function
    def documents
      view_path = File.join(RAILS_ROOT, "app", "views", "documents")
      Dir[File.join(view_path, "*.html.erb")].collect do |template|
        base_name = File.basename(template)
        if /\A_/ =~ base_name
          nil
        else
          base_name.split(/\./, 2)[0]
        end
      end.compact
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
