module PagesHelper
  def page_published_label(page)
    if page.published?
      t("Published")
    else
      t("Draft")
    end
  end
end
