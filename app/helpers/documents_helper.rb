module DocumentsHelper
  def usage_path
    url_for(:controller => "documents", :action => "usage")
  end
end
