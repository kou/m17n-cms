# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def extjs_path(source)
    compute_public_path(source, "extjs")
  end

  def tiny_mce_path(source)
    compute_public_path(source, "tiny_mce")
  end

  def extjs_include_tag
    tags = [
            "resources/css/ext-all.css",
            "adapter/prototype/ext-prototype-adapter.js",
            "ext-all-debug.js",
           ].collect do |source|
      path = extjs_path(source)
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
    javascript_include_tag(tiny_mce_path("tiny_mce_src.js"))
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
