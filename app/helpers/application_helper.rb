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

  def page_tree_data
    Page.roots.collect do |page|
      page_to_tree_data(page)
    end
  end

  def page_to_tree_data(page)
    expanded = false
    children = page.contents.collect do |content|
      content_expanded = current_page?(content_path(content))
      expanded = true if content_expanded
      {
        "text" => "#{content.language}: #{content.title}",
        "href" => content_path(content),
        "expanded" => content_expanded,
        "leaf" => true,
      }
    end
    children += page.children.collect do |child|
      child_tree_data = page_to_tree_data(child)
      expanded = true if child_tree_data["expanded"]
      child_tree_data
    end
    tree_data = {
      "text" => page.name,
      "href" => page_path(page),
      "children" => children,
      "leaf" => false,
    }
    tree_data["expanded"] = true if expanded or current_page?(page_path(page))
    tree_data
  end

  def content_tabs_data(page)
    AVAILABLE_LANGUAGES.collect do |language|
      content = page.contents.find_or_create_by_language(language)
      content.update_attribute(:title, page.name) if content.title.blank?
      {
        "title" => "#{language}: #{h(content.title)}",
        "html" => content.body,
      }
    end
  end
end
