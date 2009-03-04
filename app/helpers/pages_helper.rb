module PagesHelper
  def page_published_label(page)
    if page.published?
      t("Published")
    else
      t("Draft")
    end
  end

  def page_tree_data
    Page.sorted.find(:all).collect do |page|
      page_to_tree_data(page)
    end
  end

  def page_to_tree_data(page)
    expanded = false
    children = page.sorted_contents.collect do |content|
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

  def page_content_tabs_data(page)
    page.sorted_contents.collect do |content|
      language = content.language
      {
        "title" => t(language, :locale => language, :default => language),
        "iconCls" => "tab-language-icon language-icon-#{language}",
        "contentEl" => content_preview_id(content),
        "tbar" => [{
                     "text" => t("Edit"),
                     "href" => edit_content_path(content),
                   }],
      }
    end
  end

  def page_active_content_tab_index(page)
    default_content = page.sorted_contents.find do |content|
      content.language == I18n.locale.to_s
    end
    page.sorted_contents.index(default_content) || 0
  end
end
