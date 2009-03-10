module DocumentsHelper
  def title
    return super unless controller.is_a?(DocumentsController)
    page_title = document_page_title(controller.action_name)
    return super if sub_title.blank?
    h("#{site_title} - #{page_title}")
  end

  def general_usage_document_path
    url_for(:controller => "documents", :action => "usage")
  end

  def image_upload_document_path
    url_for(:controller => "documents", :action => "image")
  end

  def ftp_upload_document_path
    url_for(:controller => "documents", :action => "ftp")
  end

  def experienced_usage_document_path
    url_for(:controller => "documents", :action => "experienced")
  end

  def document_page_title(action_name)
    case action_name
    when "usage"
      t("General usage")
    when "image"
      t("Image upload")
    when "ftp"
      t("FTP upload")
    when "experienced"
      t("Experienced usage")
    else
      nil
    end
  end
end
