module ContentsHelper
  def content_preview_id(content)
    "content-#{content.language}-preview"
  end

  def content_edit_toolbar_data(current_content)
    content_toolbar_data(current_content) do |content|
      edit_content_path(content)
    end
  end

  def content_show_toolbar_data(current_content)
    content_toolbar_data(current_content) do |content|
      content_path(content)
    end
  end

  def normalize_content_body(body)
    body
  end

  def content_links(content)
    current_page = content.page
    Page.sorted.find(:all).reject do |page|
      page == current_page
    end.collect do |page|
      other_content = page.contents.find_or_create_by_language(content.language)
      [other_content.title, static_content_path(other_content)]
    end
  end

  private
  def content_toolbar_data(current_content)
    page = current_content.page
    page.sorted_contents.collect do |content|
      data = {
        "iconCls" => "language-icon-#{content.language}",
      }
      if current_content == content
        data["disabled"] = true
      else
        data["href"] = yield(content)
      end
      data
    end
  end
end
