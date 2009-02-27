module ContentsHelper
  def content_preview_id(content)
    "content-#{content.language}-preview"
  end

  def content_tabs_data(page)
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
