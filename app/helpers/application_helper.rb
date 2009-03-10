# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def extjs_include_tag
    tags = [
            "resources/css/ext-all.css",
            "adapter/prototype/ext-prototype-adapter.js",
            "ext-all-debug.js",
           ].collect do |source|
      tag = ExtjsAssetTagHelper::ExtjsTag.new(@template, @controller, source)
      path = tag.public_path
      case path.sub(/\?.*\z/, '')
      when /\.css\z/
        stylesheet_link_tag(path)
      when /\.js\z/
        javascript_include_tag(path)
      else
        path
      end
    end
    tags << javascript_include_tag("prototype-patch.js")
    tags.join("\n")
  end

  def tiny_mce_include_tag
    tag = TinyMceAssetTagHelper::TinyMceTag.new(@template, @controller,
                                                "tiny_mce_src.js")
    path = tag.public_path
    javascript_include_tag(path)
  end

  def icon_tag(language)
    image_tag("icons/#{language}-icon.gif", :alt => language)
  end

  def site_title
    Site.default.title || t("Site Title")
  end

  def title
    controller_title = t("title.controller.#{controller.controller_name}")
    action_title = t("title.action.#{controller.action_name}")
    h("#{site_title} - #{controller_title} - #{action_title}")
  end
end
