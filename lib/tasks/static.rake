# -*- ruby -*-

namespace :static do
  desc "Generate static HTML"
  task :generate => :environment do
    require 'action_controller/test_process'
    require 'static_helper'

    output_dir = ENV["M17N_CMS_OUTPUT_DIR"]
    output_dir ||= File.join(RAILS_ROOT, "public", "static")
    FileUtils.rm_rf(output_dir) if File.exist?(output_dir)
    FileUtils.mkdir_p(output_dir)

    output_image_dir = File.join(output_dir, "images")
    FileUtils.mkdir_p(output_image_dir)
    icons_dir = File.join(ActionView::Helpers::AssetTagHelper::ASSETS_DIR,
                          "images", "icons")
    FileUtils.cp_r(icons_dir, File.join(output_image_dir, "icons"))

    output_stylesheets_dir = File.join(output_dir, "stylesheets")
    FileUtils.cp_r(ActionView::Helpers::AssetTagHelper::STYLESHEETS_DIR,
                   output_stylesheets_dir)

    [:ImageTag, :JavaScriptTag, :StylesheetTag].each do |tag_class|
      ActionView::Helpers::AssetTagHelper.const_get(tag_class).module_eval do
        include StaticHelper::AssetPath
      end
    end
    ContentsController.helper(StaticHelper)

    Page.find(:all).each do |page|
      page.contents.each do |content|
        output_file_name = content.html_path(output_dir)
        controller = ContentsController.new
        request = ActionController::TestRequest.new("id" => content.id)
        request.action = "static"
        response = ActionController::TestResponse.new
        controller.process(request, response)
        File.open(output_file_name, "w") do |html|
          html.print(response.body)
        end
        if content.language == "ja"
          FileUtils.cp(output_file_name, page.html_path(output_dir))
        end
      end
    end
  end
end
