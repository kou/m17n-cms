module DocumentsHelper
  def title
    return super unless controller.is_a?(DocumentsController)
    case controller.action_name
    when "usage"
      sub_title = t("General usage")
    when "image"
      sub_title = t("Image upload")
    when "ftp"
      sub_title = t("FTP upload")
    when "experienced"
      sub_title = t("Experienced usage")
    else
      return super
    end
    h("#{site_title} - #{sub_title}")
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
end
