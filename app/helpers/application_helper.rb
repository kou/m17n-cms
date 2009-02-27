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
    end.join("\n")
  end

  def tiny_mce_include_tag
    tag = TinyMceAssetTagHelper::TinyMceTag.new(@template, @controller,
                                                "tiny_mce.js")
    path = tag.public_path
    javascript_include_tag(path)
  end

  def page_tree_data
    Page.sorted.find(:all).collect do |page|
      page_to_tree_data(page)
    end
  end

  def page_to_tree_data(page)
    expanded = false
    children = page.contents.collect do |content|
      current_page = current_page?(:controller => "contents",
                                   :action => controller.action_name,
                                   :id => content.id)
      expanded = true if current_page
      {
        "text" => h(content.title),
        "href" => content_path(content),
        "leaf" => true,
        "cls" => current_page ? "current" : "",
        "iconCls" => "language-icon-#{content.language}",
        "expanded" => current_page,
      }
    end
    expanded ||= !children.find {|child| child["expanded"]}.nil?
    expanded ||= current_page?(:controller => "pages",
                               :action => controller.action_name,
                               :id => page.id)
    {
      "text" => page.name,
      "href" => page_path(page),
      "children" => children,
      "leaf" => false,
      "cls" => expanded ? "current" : "",
      "expanded" => expanded,
    }
  end

  def icon_tag(language)
    image_tag("icons/#{language}-icon.gif", :alt => language)
  end
end
